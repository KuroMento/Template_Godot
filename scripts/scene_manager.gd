#SceneManger
## Pour m'utiliser, tapez simplement SceneManager dans n'importe quel script et j'apparaitrais
## comme par magie ! (ou presque)
##
## Cette classe permet de changer de scene en utilisant qu'une seule instance du noeud placée
## à la root de l'arborescence du jeu. Inaccessible en temps normal, il existe des manière pour
## récupérer la référence du noeud mais ce n'est pas conseillé (à moins de vouloir du mal à votre
## petit jeu).
extends Node

signal scene_changed

var _path:String = ""

var loading_screen_scene = preload("res://scenes/loading_screen.tscn")
var loading_screen: LoadingScreen = null
var _loading_timer: Timer = null
var _start_transition:String
var _finish_transition:String

## Utilisez moi pour changer d'une scène à une autre !
func change_scene(path:String = "res://scenes/game_menu.tscn", start_transition:String = "fade_to_black", finish_transition:String = "fade_from_black") -> void:
	# Cette fonction peut souvent être appellée par un signal,
	# ou une autre fonction dans la scène courante.
	# Détruire la scène actuelle à ce moment est
	# une mauvaise idée, il se peut qu'elle execute encore du code.
	# Cela peut provoquer un crash ou des comportements inattendus.

	# La solution est de relayé l'execution pour plus tard, quand
	# nous serons sur qu'aucun code de la scéne actuelle s'execute:
	_start_transition = start_transition
	_finish_transition = finish_transition
	call_deferred("_deferred_change_scene",path,start_transition)

func _deferred_change_scene(path:String = "res://scenes/game_menu.tscn", transition:String = "fade_to_black") -> void:
	loading_screen = loading_screen_scene.instantiate() as LoadingScreen # On charge notre noeud de transitions
	get_tree().root.add_child(loading_screen) # on l'ajoute à la ROOT pour cacher la scene actuelle
	loading_screen.start_transition(transition) # on démarre sans attendre la transition
	_load_new_scene(path) #on va charger notre nouvelle scene en fond, viens voir plus bas !

func _load_new_scene(path:String)->void:
	_path = path # On met à jour le nouveau chemin pour le chargement
	
	if loading_screen != null: # Si on fait une transition, alors on attend la fin de celle-ci (d'ou le custom signal)
		await loading_screen.first_transition_completed
	
	# On charge notre nouvelle scène en fond (threading!)
	var loader = ResourceLoader.load_threaded_request(path)
	if not ResourceLoader.exists(path) or loader == null:
		printerr("Votre chemin est invalide, ca marche pas >w< ")
	
	# Ici on ajoute un timer pour vérifier à un certain interval le taux de chargement.
	# C'est utile pour les barres de chargements -> [XXXXXXXXX-] 99%
	_loading_timer = Timer.new()
	_loading_timer.wait_time = 0.1
	_loading_timer.timeout.connect(_check_load_status) # Toutes les 0.1s, on lance le check !
	get_tree().root.add_child(_loading_timer) # Faut pas oublier d'ajouter le timer !
	_loading_timer.start()

func _check_load_status()->void:
	# On récupère le chargement de notre nouvelle scène en fond de celle actuelle (threading!)
	var load_status = ResourceLoader.load_threaded_get_status(_path)
	
	
	match load_status:
		ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
			printerr("Invalid resource: ", _path)
			pass
		ResourceLoader.THREAD_LOAD_FAILED:
			printerr("Failed to load: ", _path)
			pass
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			print("Loading: ", _path)
			pass
		ResourceLoader.THREAD_LOAD_LOADED:
			# C'est le cas où on a fini le chargement. On arrete et détruit notre timer.
			_loading_timer.stop()
			_loading_timer.queue_free()
			# On récupère la scène charge dans la mémoire en fond pour l'instancier (threading!)
			var new_scene = ResourceLoader.load_threaded_get(_path).instantiate()
			get_tree().current_scene.call_deferred("free") # On détruit notre scène actuelle
			get_tree().root.call_deferred("add_child",new_scene) # On ajoute la nouvelle scène à la root
			get_tree().set_deferred("current_scene",new_scene) # On définit notre scène actuelle comme étant la nouvelle
			loading_screen.finish_transition(_finish_transition) # On finit notre transition
			scene_changed.emit() # On dit qu'on a finit (utile pour de la logique dans d'autre script appelant le manager)

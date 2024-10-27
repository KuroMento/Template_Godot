class_name BoucleGodot
## Cycle de vie de Godot
##
## Cette classe vous sert à comprendre la manière et l'ordre dans lequel est organisé l'appel
## aux fonctions primordiales au bon fonctionnement de votre jeu. Elles ne sont pas toujours
## requises dans chaque script mais si vous en avez besoin à un moment tout est là. 
## Ajoutez-moi à une scène et observez ^^.
extends Node

@export var time_passed:float = 0.0 ## Le temps écoulé depuis l'execution de _ready
@export var max_time:float = 60.0 ## 1 min à vivre, quelle tristesse !

## Appel lorsque que le noeud entre dans l'arborescence
func _enter_tree() -> void:
	print("Le noeud BoucleGodot est entré dans votre scène")

## Appel lorsque tout ses noeuds enfants sont entré dans l'arborescence et
## ont appelé leur fonction _ready. Attention alors entre l'initialisation des
## noeuds enfants et parents si l'un ou l'autre à besoin de certaines données
## ou d'une référence (comme @onready).
func _ready() -> void:
	print("Moi-même et mes enfants sont prêt à être référencés dans votre code")
	Object.new()

## Appel lorsque vous créer un objet de la classe [BoucleGodot] en utilisant la méthode
## de base [method GDScript.new]. C'est simplement le constructeur de votre classe
func _init() -> void:
	# Initialiser des variables si nécessaire ici.
	# Plus pratique si vous générer des objets à l'execution !
	pass

## Appel lorsque qu'un input est détecté. Cela peut être une touche comme les mouvements de la souris
## ou même le pavé tactile ! Très pratique pour distinguer les inputs puisqu'il sont en paramètres
## de la fonction ([param event]). Voir [InputEvent] pour plus de détails sur les inputs.
func _input(event: InputEvent) -> void:
	var space_pressed:bool = event.is_action_pressed("ui_accept")
	if (space_pressed) :
		print("Vous avez appuyé sur espace, n'est-ce pas ?")

## Cette fonction n'est appelée que si vous n'avez pas défini ou assigné votre input.
## Dans ce projet, les touches assignées sont celles dans Project > Settings > Input Map.
## [color=yellow]/!\ Cela n'inclut pas les touches ui_* que vous pouvez voir en cochant la case
## pour les "built-in" actions.[/color]
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouse or event is InputEventMouseMotion or event is InputEventMouseButton:
		print("souris --(__ô>")
		return
	if event.is_pressed():
		print("Voila un input non assigné, c'est pas bien de toucher à tout ^^")
	if event.is_released():
		print("C'est bien et que je ne te vois pas y retoucher surtout !")

## Appel à chaque frame et équivalent à while true. Le paramètre [param delta] est là pour
## vous indiquer le temps passé entre cahque frame. Une utilisation courante est de le multiplier
## à la vitesse du joueur pour quelle reste constante qu'importe le framerate (sinon certains
## pourraient être plus rapide que d'autres en ligne O_O)
func _process(delta: float) -> void:
	time_passed += delta
	if time_passed > max_time:
		print("Il est l'heure, toute les bonnes choses ont une fin")
		queue_free()
	elif time_passed > max_time/2  and time_passed < (max_time/2 + delta):
		print(self) #on va appeler to_string pour la démonstration quand même

## Appel similaire à _process mais mieux adapté à la physique de Godot. A utiliser
## lorsque l'on est sûr que le noeud aura des collisions avec d'autres noeuds.
## Le principe pour le delta est le même mais on rajoute un underscore ou _ devant
## pour indiquer que le param est ici non utilisé. 
func _physics_process(_delta: float) -> void:
	pass

## Appel lorsque que vous faites print([BoucleGodot]). C'est l'affichage de votre objet dans la console !
func _to_string() -> String:
	return "La boucle Godot a encore " + str(max_time - time_passed) + " à vivre !"

## Appeler lorsque que le noeud quitte l'arborescence
func _exit_tree() -> void:
	print("J'ai quitté votre scène, bye bye")

# ---------- BONUS ----------

## Appel lorsque certains evenements prédéterminé surviennent. Le paramètre
## nommé [code]what[/code] indique de quel evenement il s'agit. C'est un entier
## puisque les evenements sont représentés par des constantes accessibles
## dans la classe [Object]
func _notification(what: int) -> void:
	#print(what) | enlever le comment si ca vous intéresse uniquement !
	pass

class_name SplitScreen
## Une simple manière de faire un jeu en co-op local avec écran partagé statique
##
## Cette classe va vous permettre de découvrir comment on réaliser un jeu en
## écran partagé avec les [SubViewport] qui doivent tous être reliés à un
## [SubViewportContainer] afin de délimiter la zone sur laquelle on affiche
## la perspective d'un ou plusieurs joueurs.
extends CanvasLayer

## Définit le nombre de joueurs que l'on souhaite avoir en même temps sur un écran
@export var nb_players := 2
## On récupère les différents sprite disponibles
var player_sprites: Array[int] = [0,2,4,6]
## On récupère la référence à la scène où jouent nos joueurs pour avoir accès à leur noeud.
## Ce qui va nous servir pour faire l'initialisation par la suite dans ce script.
@onready var simple_2d_game: Simple2D = $GridContainer/SubViewportContainer/SubViewport/Simple2DGame
## On récupère tous nos [SubViewport] pour pouvoir les afficher dynamiquement en fonction du nombre de joueurs.
@onready var grid_container: GridContainer = $GridContainer

func _ready() -> void:
	# On s'assure d'avoir entre 2 et 4 joueurs sinon on force quit
	if nb_players > 4 or nb_players < 2:
		get_tree().quit()
		return
	
	# Ici, on va instancier tous les joueurs et afficher dans la fenêtre principale leur [SubViewportContainer] dédié.
	for i in range(nb_players):
		simple_2d_game.add_split_screen_player(player_sprites.pop_front())
		grid_container.get_child(i).show()
	
	# On récupère toutes les cameras des joueurs à l'aide des groupes (très pratique n'est-ce pas?)
	var players_cameras := get_tree().get_nodes_in_group("SplitCamera")
	
	# Pour chaque joueur dans notre jeu, on va lui associer une caméra en créer un noeud
	# qui va répliquer sa position sur le noeud dont on choisi le chemin / path 
	# (ici celle du joueur auquel on l'attache)
	for player in simple_2d_game.players.get_children():
		var remote_transform := RemoteTransform2D.new()
		var player_cam := players_cameras.pop_front() as Camera2D # On utilise notre tableau de caméras comme une file (FIFO)
		remote_transform.remote_path = player_cam.get_path()
		player.add_child(remote_transform)
	
	# On récupère maintenant la référence au monde et ses éléments pour les copier sur les
	# autres viewports. Cela va nous permettre d'avoir plusieurs écrans pour le même monde !
	var game_world_2d := (grid_container.get_child(0).get_child(0) as SubViewport).world_2d
	
	# Pour le reste des Viewports qui n'ont pas le noeud Simple2D, on leur définit le monde à afficher
	# grâce aux partage des données. En gros, on définit ce qui existe à partir du noeud Simple2D pour
	# que le Viewport comprenne ce qu'il faut afficher à partir des données des noeuds.
	# La caméra qu'on a déjà initialiser va délimiter ce qui est affiché du monde !
	for i in range(1,nb_players):
		(grid_container.get_child(i).get_child(0) as SubViewport).world_2d = game_world_2d
	
	# Passons maintenant à l'attribution des inputs
	var index := 1
	var control_id := 0
	for player in simple_2d_game.players.get_children():
		var typed_player : SplitScreenPlayer = player as SplitScreenPlayer
		
		if FileAccess.file_exists("res://scripts/ressources/player_" + str(index) + ".tres"): # Si les controles existent, on les ajoute
			var controls = load("res://scripts/ressources/player_" + str(index) + ".tres") as PlayerControls # On récupère les controles
			typed_player.controls = controls
			index += 1
		else: # Sinon, on utilise l'identifiant pour les manettes
			typed_player.control_id = control_id
			control_id += 1 # on incrémente à la fin pour ne pas attribuer les controles d'une manette à deux joueurs 

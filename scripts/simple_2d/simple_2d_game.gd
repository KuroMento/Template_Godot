class_name Simple2D
## Classe basique
##
## La classe Simple2D ne sert qu'a obtenir des références que l'on pourra
## utiliser pour faire l'initialisation de notre scène pour les écrans
## partagés et donc du multijoueur en local.
extends Node2D

## On récupère un noeud tampon pour y instancier tous les joueurs de la partie.
@onready var players: Node2D = $Players
## Variable pour définir l'initialisation de la scène Simple2D. C'est pratique pour savoir si
## l'on instancie plutôt un joueur lorsque l'on veut simplement voir en action un plateformer
## ou si l'on veut directement instancier plusieurs joueurs dans le niveau.
@export var split_screen:bool = false

func _ready() -> void:
	if players and not split_screen:
		var single_player : Player = load("res://scenes/simple_2d/player.tscn").instantiate() as Player
		players.add_child(single_player)

func add_split_screen_player(sprite_id := 0) -> void:
	if players and split_screen:
		var split_screen_player:SplitScreenPlayer = load("res://scenes/simple_2d/split_screen/split_screen_player.tscn").instantiate() as SplitScreenPlayer
		split_screen_player.sprite_id = sprite_id
		players.add_child(split_screen_player)
		split_screen_player.name = "Player" + str(players.get_child_count())

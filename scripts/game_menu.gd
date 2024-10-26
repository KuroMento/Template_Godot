class_name MainMenu
extends CanvasLayer

## Cette classe représente le menu principal ainsi que toutes les interactions disponibles sur
## celui-ci comme les différents boutons pour que vous puissez les fonctionnalités derrière le
## code.

func _ready():
	print("Bienvenue dans ce template de la formation Godot !")

## Permet de quitter le template lorsque vous appuiez sur QUIT. 
func on_quit_pressed() -> void:
	print("Au revoir !")
	# Pour fermer la fenêtre, vous récupérer toute l'arborescence depuis la root
	# et vous faites quit() pour détruire toutes les instances des noeuds incluant
	# les scripts autoload comme le SceneManger
	get_tree().quit()

## Vous amène vers un simple plateformer qui démontrer les capicités du moteur comme
## les signaux, les zones (Area2D), les ressources (enemmies) et les collisions. 
func on_simple2d_game_pressed() -> void:
	SceneManager.change_scene("res://scenes/simple_2d_game.tscn")

## Vous amène vers une scène en split-screen. Le code de la scèneen question comprend 
## aussi la manière de gérer différents inputs clavier et manettes.
func on_split_screen_pressed() -> void:
	pass

## Vous amène vers la scène que je vous ai présenté pendant la formation.
## Le plus intéressant sera le code pour mieux comprendre mais si vous voulez
## tester, il faudra avoir deux instances de votre fenêtre de debug.
## Pour cela, Debug > Custom Run Instances > Enable Multiple Instances (en haut à gauche)
## puis mettre 2 instances ou plus si vous voulez tester pour 3, 4, etc.
func on_multiplayer_pressed() -> void:
	SceneManager.change_scene("res://scenes/multiplayer_game.tscn")

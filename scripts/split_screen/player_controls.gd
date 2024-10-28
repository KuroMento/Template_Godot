class_name PlayerControls
## Cela représente un ensemble d'action disponibles pour un joueur
##
## Cette classe définit une chaîne de charactères [b][u]par action à configurer[/u][/b]
## pour que chacun des joueurs puissent jouer à l'aide des [color=red]touches du clavier !!![/color].
## Cela veut dire que faire des ressources pour des inputs manette est complètement inutile mais grâce à
## cette classe, vous pourrez faire des jeux hybrides clavier-manette.
extends Resource


@export_group("PlayerActions")
@export var move_left := ""
@export var move_right := ""
@export var jump := ""

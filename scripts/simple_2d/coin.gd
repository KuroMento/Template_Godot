class_name Coin
## C'est un collectible
##
## Représente une pièce comme on pourrait en voir dans différents comme Mario
## mais, ici, le nombre de pièces que vous récoltez n'est pas décompté, ni affiché.
extends Area2D

## L'[AnimationPlayer] permet de faire des animations, ici pour modifier les frames du sprite
## et plusieurs images à la suite c'est exactement une animation !
@onready var animation: AnimationPlayer = $Animation

## Quand le joueur (voir collision layer et mask) entre en contact avec la pièce, on la détruit.
## Vous ne la collecterez qu'une seule fois de cette manière
func _on_player_collision(body: Node2D) -> void:
	print("Coin collected !")
	queue_free()

## On fait tourner la pièce dès qu'elle est prête !
func _ready() -> void:
	if animation.has_animation("spin"):
		animation.play("spin")

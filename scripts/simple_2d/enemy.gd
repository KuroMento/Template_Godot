class_name Enemy
## Un ennemi simple
##
## C'est une entité qui ne fais que des aller-retours en détectant les murs
## grâce à un [RayCast2D] pour ensuite changer de direction. Vous remarquerez
## que cet ennemi n'est pas soumis à la physique du moteur (excluant sa zone de collision)
## et donc qu'il ne tombera pas dans le vide !
extends Node2D

## Le rayon projeté pour détecter les collisions avec l'environnement
@export var raycast:RayCast2D
## La taille du rayon fixée. Distance à partir de laquelle l'ennemi voit
## le mur qui se trouve en face de lui
const RAY_LENGTH:int = 10

## Pour les animations, on change les frames du sprite.
@export var animation:AnimationPlayer

## La direction générale dans laquelle se déplace l'ennemi. En se basant sur ce code, elle
## ne peut être que [constant Vector2.LEFT] ou [constant Vector2.RIGHT].
var direction: Vector2 = Vector2.LEFT
## La vitesse de notre ennemi.
const ENEMY_SPEED = 75
## Le sprite de l'ennemi pour faire des flip de celui-ci quand on change de [member direction]
@onready var sprite_2d: Sprite2D = $Sprite2D

## On anime notre cher ennemi et on initialise la direction dans laquelle pointe notre [RayCast2D].
func _ready() -> void:
	if animation.has_animation("walk"):
		animation.play("walk")
	raycast.target_position = direction * RAY_LENGTH

## On fait bouger notre ennemi dans physics puisqu'on doit gérer les collisions
## entre l'environnement et le raycast.
func _physics_process(delta: float) -> void:
	global_position += direction * delta * ENEMY_SPEED
	
	raycast.force_raycast_update() #on met à jour immédiatement avant de vérifier (juste pour être sur)
	if raycast.is_colliding(): # si on rentre dans un mur
		direction = direction * (-1) #on part dans le sens inverse
		raycast.target_position = direction * RAY_LENGTH # On met à jour la direction du raycast
		sprite_2d.flip_h = not sprite_2d.flip_h #on met à jour le sprite

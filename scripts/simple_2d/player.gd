class_name Player
## C'est vous
##
## Cette scène ne peut pas en l'état être réutilisé pour faire du split-screen et vous
## pouvez observer la différence en allant voir du côté de l'autre joueur
extends CharacterBody2D

## Le sprite du personnage
@onready var sprite_2d: Sprite2D = $Sprite2D

## Définit votre point de réapparition
var spawn_point: Marker2D

const SPEED = 125.0
const JUMP_VELOCITY = -350.0

## On récupère ici notre point de réapparition.
func _ready() -> void:
	spawn_point = get_tree().get_first_node_in_group("Spawn")
	if spawn_point:
		global_position = spawn_point.global_position

## Les différentes lines sont celles générées par Godot pour le mouvement d'un [CharacterBody2D].
func _physics_process(delta: float) -> void:
	# Ajout de la gravité
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Espace + être sur le sol = saut !
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# On récupère l'input 
	var direction := Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
		
		# Simplement de quoi faire tourner le sprite
		if direction >= 0:
			sprite_2d.flip_h = true
		else:
			sprite_2d.flip_h = false
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide() # Fais bouger le joueur selon velocity (qu'on modifie à chaque frame en fonction des inputs)

## Vous replace à l'endroit définit dans [method _ready].
func respawn() -> void:
	print("Vous êtes mort mais c'est pas vraiment un problème, si ?")
	global_position = spawn_point.global_position

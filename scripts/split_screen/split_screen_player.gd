class_name SplitScreenPlayer
## C'est un joueur en multijouer local
##
## L'objectif est de créer dynamiquement les joueurs en local en fonction du nombre de joueurs que vous voulez.
## On leur attribuera alors un [RemoteTransform2D] pour leur assigner une [Camera2D] qui n'est pas présente actuellement
## dans l'arborescence des noeuds de la scène.
extends CharacterBody2D

## Le sprite du personnage
@onready var sprite_2d: Sprite2D = $Sprite2D
var sprite_id := 0

# L'identité du joueur
## Ceci est l'identifiant pour la manette de jeu, on va l'utiliser pour déterminer quelle manette a un
## impact sur le mouvement de quel joueur.
@export var control_id := 0
## On définit une ressource qui va simplement conserver les chaînes de caractères pour chaque
## action du joueur. L'inconvénient, c'est qu'il faudra créer des actions dans les paramètres du
## projet au préalable ainsi que les ressources qui les relient ce qui n'est pas du tout dynamique.
## Le mieux serait que chacun est une manette mais pour ce template, vous aurez aussi la possibilité
## de le tester au clavier
@export var controls:PlayerControls = null

## Définit votre point de réapparition
var spawn_point: Marker2D

const SPEED = 125.0
const JUMP_VELOCITY = -350.0

## On récupère ici notre point de réapparition et on initialise notre sprite aléatoirement parmi
## une sélection limitée à 4 choix.
func _ready() -> void:
	spawn_point = get_tree().get_first_node_in_group("Spawn")
	sprite_2d.frame = sprite_id
	# On se positionne au départ
	if spawn_point:
		global_position = spawn_point.global_position

## Les différentes lines sont celles générées par Godot pour le mouvement d'un [CharacterBody2D].
func _physics_process(delta: float) -> void:
	var direction
	# Ajout de la gravité
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if controls: #Si on a des inputs clavier, on récupère notre saut et direction
		# Espace + être sur le sol = saut !
		if Input.is_action_just_pressed(controls.jump) and is_on_floor():
			velocity.y = JUMP_VELOCITY
		# On récupère la direction avec Input clavier
		direction = Input.get_axis(controls.move_left, controls.move_right)
	
	elif Input.is_joy_known(control_id): # Si on a plutôt des inputs manettes ACTIF (sinon on va chercher une manette qui n'existe pas!
		# Bouton A (X-Box) + être sur le sol = saut !
		# Vous pouvez voir quel bouton de votre manette correspond à l'énumération dans les inputs du projet
		if Input.is_joy_button_pressed(control_id,JOY_BUTTON_A) and is_on_floor():
			velocity.y = JUMP_VELOCITY
		direction = Input.get_joy_axis(control_id,JOY_AXIS_LEFT_X)
	
	# Si on a des inputs clavier ou manettes, on applique la direction voulue
	if direction and abs(direction) > 0.1:
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
	print("Vous êtes mort " + name + " mais c'est pas vraiment un problème, si ?")
	global_position = spawn_point.global_position

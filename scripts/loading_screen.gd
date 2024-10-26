class_name LoadingScreen
extends CanvasLayer

signal first_transition_completed

@onready var anim_player:AnimationPlayer = %AnimPlayer

func start_transition(anim_name:String)->void:
	#On vérifie si l'on a bien notre noeud pour les animations
	if !anim_player:
		anim_player = get_node("AnimPlayer") as AnimationPlayer
	
	# On vérifie aussi si l'animation souhaitée existe (quand même!)
	if !anim_player.has_animation(anim_name):
		push_warning("'%s' start animation does not exist!" % anim_name)
	
	# On peut jouer notre animation maintenant
	anim_player.play(anim_name)

func finish_transition(anim_name:String)->void:
	# Checking if the animation exist within the loading animation player
	if !anim_player.has_animation(anim_name):
		push_warning("'%s' finish animation does not exist!" % anim_name)
	anim_player.play(anim_name)
	
	await anim_player.animation_finished
	queue_free()

## Utiliser pour envoyer un signal via une animation. Ici c'est pour indiquer que notre première transition
## c'est très bien déroulé et qu'on va pouvoir finir la transition par la suite.
func complete_first_transition()->void:
	first_transition_completed.emit()

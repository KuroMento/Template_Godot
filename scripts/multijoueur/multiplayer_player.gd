class_name MultiplayerPlayer
## Une classe pour créer un joueur capable de se mouvoir 
##
## Il n'y a pas tant que ca à dire mais si cela vous intéresse, je vous conseille d'aller voir
## la rediffusion de la formation sur le peertube d'atilla
extends CharacterBody2D

# Parametres du scripts
## La vitesse de tous les joueurs (Serveur et Clients)
const SPEED:float = 300.0
## La direction dans laquelle se déplce le joueur en fonction de ses inputs.
var direction:Vector2 = Vector2.ZERO

## Comme dans BoucleGodot, [method _enter_tree] ne s'actve que lorque le 
## joueur est instancié et on y définit son autorité par rapport à son nom
## qu'on a changer pour être l'identifiant du client/serveur.
##
## Pour rappel, l'autorité définit les actions qui vous sont disponibles. Retour à la rediff pour plus d'info.
func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())

## On récupère la direction que si vous avez le droit de le faire. Vous
## n'allez quand même pas bouger tous les joueurs en même temps ? Enfin
## rien ne vous empêche d'essayer X_X
func _physics_process(_delta: float) -> void:
	if is_multiplayer_authority():
		direction = Input.get_vector("Left","Right","Up","Down")
		velocity = direction * SPEED
	move_and_slide() # Méthode de CharacterBody2D déplacant le noeud 2D en fonction de la velocité

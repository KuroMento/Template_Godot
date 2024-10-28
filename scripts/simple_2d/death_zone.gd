class_name DeathZone
## Tue le joueur qui s'en approche
##
## C'est une scène à part que vous pourrez réutiliser de plusieurs manières.
## Ici, je l'ai utilisé lorsque vous tombez dans le vide, sur des piques ou en rentrant
## en collision avec un ennemi.
extends Area2D

## La fonction qui se déclenche lorsque le joueur entre en contact avec la zone.
## Comme on récupère qu'un noeud 2D, il faut qu'on vérifie si c'est un Joueur puis
## on créer une variable locale pour forcer le typage du Joueur sur celle-ci et
## avoir accès à la méthode [method Player.respawn]
func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		var player := body as Player
		player.respawn()
	if body is SplitScreenPlayer:
		var player := body as SplitScreenPlayer
		player.respawn()

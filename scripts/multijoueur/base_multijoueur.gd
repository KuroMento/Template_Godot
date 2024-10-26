class_name MultiplayerGame
## La racine/root de votre scène multijoueur
##
## L'objectif de cette classe est de vous apprendre à utiliser [MultiplayerAPI] à l'aide de la
## propriété de chaque noeud : [member Node.multiplayer]. Vous pourrez créer des jeux en ligne mais
## ce sera restreint à du P2P (i.e Un des joueurs est le serveur sur lequel tous les clients jouent).
extends Node2D

## Le [code]peer[/code] représente un joueur qu'importe qu'il soit un client ou un serveur. On appliquera
## la méthode adaptée pour créer un serveur ou un client à l'aide du port et de l'adresse IP.
var peer:ENetMultiplayerPeer = ENetMultiplayerPeer.new()
## Simplement une référence à l'UI pour pouvoir l'afficher ou la cacher.
@onready var v_box_container: VBoxContainer = $CanvasLayer/MarginContainer/VBoxContainer
## La scène que l'on charge dynamiquement pour ajouter des joueurs sur le serveur.
@export var player_scene: PackedScene
## C'est un noeud dit [i]tampon[/i] qui va nous permettre de stocker tous les noeuds
## représentant les joueurs pour plus de lisibilité et d'accessibilité aux noeuds des joueurs.
var players_on_host:Node2D

@export_group("Server & Client Parameters")
## L'adresse locale ou public du réseau sur lequel vont jouer les peers 
@export var server_ip = "127.0.0.1"
## L'identification de la fenetre de jeu auprès de votre machine
## afin de rediriger les paquets provenant du réseau.
@export var port = 8080

## Met à jour le port directement depuis la fenêtre de jeu dans le [LineEdit]
func port_changed(new_text:String):
	port = new_text

## Récupère votre [member MultiplayerGame.peer] et utilise la méthode [method ENetMultiplayerPeer.create_server]
## pour générer un serveur à l'aide d'un [code]port[/code] et d'un entier pour dicter
## le nombre de joueurs autorisés sur le serveur.
func _on_host_pressed() -> void:
	var error = peer.create_server(port,2) # Creation du serveur qui retourne une erreur
	match(error):
		OK: # Le serveur a bien été crée
			print("The server was created!")
		ERR_ALREADY_IN_USE: # Le port ne peut pas être attribué
			push_warning("The server has already been created!")
		ERR_CANT_CREATE: # Erreur dans la création 
			printerr("Could not create the server!")
	
	# Maintenant qu'on a crée notre serveur, il faut qu'on dise au jeu et donc à
	# l'API Multijoueur de Godot que vous êtes maintenant un serveur. Pour cela,
	# on va mettre à jour la propriété multiplayer_peer qui représente votre status
	# en ligne.
	#
	# S'il est mis à null alors vous serez déconnecté
	multiplayer.multiplayer_peer = peer
	
	# Comme vous etes désormais un serveur, il faut définir ce qu'il se passe
	# lorsque d'autres peers rejoingnent/quittent votre serveur en tant que client.
	multiplayer.peer_connected.connect(_add_player)
	multiplayer.peer_disconnected.connect(_delete_player)
	
	# Vous êtes devenu un serveur donc on cacher les éléments graphique
	# (Il y a surement une meilleure manière de faire ici)
	v_box_container.hide()
	players_on_host = get_tree().current_scene.get_node("Players")
	
	# On oublie pas d'ajouter un joueur pour représenter le serveur puisqu'il
	# s'est connecté avant qu'on connecte le signal correspondant à l'arrivée d'un client
	_add_player()

## Récupère votre [member MultiplayerGame.peer] et utilise la méthode [method ENetMultiplayerPeer.create_client]
## pour générer un nouveau client qui va se connecter sur [member server_ip] avec le [member port] correspondant
## pour s'assurer la liaison avec le bon logiciel (ici Godot)
func _on_join_pressed() -> void:
	# C'est le même principe que pour la création du serveur.
	peer.create_client(server_ip,port)
	multiplayer.multiplayer_peer = peer
	v_box_container.hide()

## Permet d'ajouter un joueur lorsqu'un client se connecte.
func _add_player(id = 1) -> void:
	if multiplayer.is_server():
		var player = player_scene.instantiate()
		# On attribue un id au joueur (ici le nom du noeud mais cela pourrait être l'attribut d'une classe
		player.name = str(id)
		# On ajoute le joueur à un moment où aucun autre code ne s'execute pour éviter des bugs
		players_on_host.call_deferred("add_child",player)
	print("New peer connected : ", id)

func _delete_player(id:int) -> void:
	var leaving_player = players_on_host.get_node(str(id))
	leaving_player.queue_free()

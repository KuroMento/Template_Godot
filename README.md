# Template_Godot
Ceci est le template de la formation Godot. Fait en premier lieu pour les participants de la Game Jam d'ATILLA sur l'année 2024 - 2025
## Installation
1. Télécharger le dépôt
2. Assurez-vous que vous ayez la version de Godot 4.3 d'installée
## Utilisation
Lancer l'executable de Godot 4.3 qui vous amènera au gestionnaire de projet. Sélectionner *Importer* puis
choisissez le clone du dépôt que vous venez de télécharger. **L'entièreté du code est documenté** ce qui veut dire que vous pouvez
ouvrir directement depuis l'éditeur en utilisant le bouton `Search Help` puis taper le nom des classes dans les différents scripts (i.e `class_name ClassToSearch` )
### Le Menu Principal
Quand vous lancerez le projet avec `F5`, vous pourrez découvrir le menu principal qui est entièrement composé de
noeuds d'interface utilisateur. Vous pouvez jouer avec la fenêtre et voir comment évoluent les différents noeuds.
### Simple 2D
Cette scène est l'équivalent d'un niveau d'un plateforme 2D démontrant les différents concepts de base
afin de créer son propre jeu comme les inputs, les signaux, la physique (Body2D, Area2D, etc.)
### Le Split-Screen
Cette scène a deux objectifs:
1. Montrez comment réaliser une séparation d'écran pour 2 à 4 joueurs avec le noeud Viewport et ses noeuds associés
2. Implémentez un système utilisant plusieurs manettes sur une machine (Requiert au moins un manette et votre clavier pour tester)
### Multijoueur avec ENET
Pour tester les fonctionnalités multijoueurs de la sccène du template, vous aurez besoin **d'activer l'execution de plusieurs instances**
afin de pouvoir lancer plusieurs fenêtre sur votre machine et **simuler le comportement en ligne** sur du localhost (généralement l'adresse IP 127.0.0.1).
Le code pour le multijoueur ne contient pas:
* De manière pour faire son propre serveur dédié. Autrement dit, un fichier pour faire tourner un serveur qui n'est pas un joueur pour définir ce qui est autorisé ou non dans votre jeu
* Un template de lobby pour afficher tout les serveurs disponibles
## License
Ce projet est sous license MIT. Cela veut dire globalement que vous pouvez faire un usage personnel ou commercial de code en y apportant les modifications que vous souhaitez.
Pour plus de détails sur la license MIT, voir le fichier `LICENSE`

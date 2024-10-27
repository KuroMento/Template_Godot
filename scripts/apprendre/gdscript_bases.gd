# Bonjour je suis un commentaire seulement visible dans le code.
## Bonjour je suis un commentaire visible dans la documentation
##
## Cette classe ne sert à rien d'autres que de vous décrire les différents mot-clés à votre disposition
## ainsi que leur utilité dans le contexte de leur utilisation. Il est préférable de regarder directement le
## code plutôt que la page de documentation.
##@tutorial(La documentation officielle à ce sujet): https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html
##@tutorial(Comment faire de la documentation soi-même): https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_documentation_comments.html 

# Définir une icone pour votre noeud dans l'éditeur (optionel):
@icon("res://icon.svg")

# Définir un nom pour la classe (optionel):
class_name BaseGDScript

# Héritage d'une classe
extends Node

# Définition des attributs

# Les signaux en premier par convention
signal signal_sended # (On décrit généralement un phénomène par convention et la nature même des signaux)

# Puis les différentes définitions de variables
var variable_a
var variable_b = "une chaine de charactère banale"
var variable_typé: int
var variable_avec_type_déduit := 123.0
var tableau = [1, 2, 3]
var tableau_typé: Array[String] = ["valeur1","valeur2"]
var dictionnaire = {"key": "value", 2: 3}
var dictionnaire2 = {key = "value", other_key = 2}

# Une Constante
const LA_REPONSE_A_LA_VIE = 42

@export_group("Groupe de variable (Inspecteur)")
@export var variable_1:int
@export var variable_2:String
@export var vector_2 : Vector2
@export var vector_3 : Vector3
@export var tableau_export: Array[int]
@export var dictionnaire_export: Dictionary

@onready var noeud_a_recuperer:Node = $Chemin/Vers/LeNoeud/Depuis/CeluiCi

# Enumérations.
enum MonEnum { MON_PARAM1, MON_PARAM2, MON_PARAM3 = 42}

# Fonctions.
func une_fontion_chargee(parametre1, parametre2:String, parametre3:int = 42) -> int:
	var variable_locale = 0
	
	if parametre1 > variable_locale:
		variable_locale += parametre1
	elif parametre2 > "L'univers":
		variable_locale += LA_REPONSE_A_LA_VIE
	else:
		variable_locale -= parametre3
	
	if (parametre1 is int or parametre3 is int) and LA_REPONSE_A_LA_VIE == parametre3:
		print("Les mots clés logique sont and, or, in et is !")
	
	for i in range(3):
		print(3-i)
	
	while variable_locale != LA_REPONSE_A_LA_VIE:
		variable_locale = LA_REPONSE_A_LA_VIE
	
	match variable_locale:
		LA_REPONSE_A_LA_VIE:
			print("Bravo vous avez tous compris à la vie!")
		parametre1:
			print("Y a erreur pk vous êtes la")
		_:
			print("Ceci est le cas par défault")
	
	return variable_locale

## Vous pouvez définir des classes internes à une autre avec leurs variables et méthodes/fonctions
class ClasseInterne:
	var variable_interne:int = 10

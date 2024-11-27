#bazowa klasa po ktorej dziedziczylyby budynki, ktore mozna wybuodwac w miescie
#budynki nie bylyby widoczne na mapie, tylko w menu miasta po nacisnieciu na miasto
#budynki dawalaby co ture np. dodatkowe zasoby albo inne korzysci jak skrocenie czasu budowy

extends Node
class_name BuildingBaseClass
#This is the class all buildings should inherit from
@export_category("Building")
## Name of the building
@export var building_name:String="Building"
## Short description of what the building does
@export_multiline var building_description:String="No description."
## Picture representing the building. should be 64x64 px
@export_file("*.png") var building_picture="res://img/essentials-4xgames-tileset/tile-village.png"
## How many units of gold are required to build this building
@export var gold_cost:int
## How many units of wood are required to build this building
@export var wood_cost:int
## How many units of stone are required to build this building
@export var stone_cost:int
## How many units of steel are required to build this building
@export var steel_cost:int
## How many units of food are required to build this building
@export var food_cost:int

var cost:Dictionary={"gold":gold_cost,
					"wood":wood_cost,
					"stone":stone_cost,
					"steel":steel_cost,
					"food":food_cost}

#intended to be called at the start of every turn
#for example to produce extra resources for
#the building's owner
func grant_boon(_building_city:City)->void:
	printerr(name+": grant_boon function is not implemented")


#pomysly budynkow do zaimplementowania:
#sawmill- dodaje drewno co ture
#quarry- dodaje kamienia co ture
#ironworks - dodaje stali co ture
#bakery- dodaje jedzenia co ture
#barracks - przyspiesza budowanie wojownikow
#school - przyspiesza budowanie pracownikow
#hospital - leczy jednostki w zasiegu miasta co ture
#mason's workshop - przywraca wytrzymalosc miasta co ture (Np. gdy straci punkty
#wytrzymalosci po ataku wroga)

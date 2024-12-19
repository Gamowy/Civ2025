#bazowa klasa po ktorej dziedziczylyby budynki, ktore mozna wybuodwac w miescie
#budynki nie bylyby widoczne na mapie, tylko w menu miasta po nacisnieciu na miasto
#budynki dawalaby co ture np. dodatkowe zasoby albo inne korzysci jak skrocenie czasu budowy

#zeby dostac obrazek budynku trzeba uzyc funkcji load(building.building_picture)
#zeby utworzyc buddynek w kodzie uzwyamy load("res://scenes/buildings/bulidingname.tscn").instantiate()
#oraz dodac do buildings w miescie w ktorym sie znajduje
# i potem najlepiej dac go jako dziecko miasta w ktorym sie znajduje city.add_child(building)

extends Node
class_name BuildingBaseClass
#This is the class all buildings should inherit from
@export_category("Building")
## Name of the building
@export var building_name:String="Building"
## Short description of what the building does
@export_multiline var building_description:String="No description."
## Picture representing the building.
@export_file("*.png") var building_picture="res://img/essentials-4xgames-tileset/tile-village.png"
@export_category("Cost")
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
@export_category("Production")
## How many units of gold the building produces per turn
@export var gold_production:int=0
## How many units of wood the building produces per turn
@export var wood_production:int=0
## How many units of stone the building produces per turn
@export var stone_production:int=0
## How many units of steel the building produces per turn
@export var steel_production:int=0
## How many units of food the building produces per turn
@export var food_production:int=0
var cost:Dictionary={"gold":gold_cost,
					"wood":wood_cost,
					"stone":stone_cost,
					"steel":steel_cost,
					"food":food_cost}

#intended to be called at the start of every turn
#for example to produce extra resources for
#the building's owner
func grant_boon(building_city:City)->void:
	building_city.city_owner.gold+=gold_production
	building_city.city_owner.wood+=wood_production
	building_city.city_owner.stone+=stone_production
	building_city.city_owner.steel+=steel_production
	building_city.city_owner.food+=food_production

func print_info():
	print("Name: "+building_name)
	print("Description: "+building_description)
	print("Picture: "+building_picture)
	print("Gold cost: "+str(gold_cost))
	print("Wood cost: "+str(wood_cost))
	print("Stone cost: "+str(stone_cost))
	print("Steel cost: "+str(steel_cost))
	print("Food cost: "+str(food_cost))

#pomysly budynkow do zaimplementowania:

#barracks - przyspiesza budowanie wojownikow
#school - przyspiesza budowanie pracownikow
#hospital - leczy jednostki w zasiegu miasta co ture
#mason's workshop - przywraca wytrzymalosc miasta co ture (Np. gdy straci punkty
#wytrzymalosci po ataku wroga)

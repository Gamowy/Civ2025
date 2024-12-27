extends Control

@onready var buildings_limit_owned: Label = $Center/CenterContainer/PanelContainer/HBoxContainer/VBoxUpgradeInfo/VBoxOwned/BuildingsLimitOwned
@onready var area_upgrade: Label = $Center/CenterContainer/PanelContainer/HBoxContainer/VBoxUpgradeInfo/VBoxUpgrade/AreaUpgrade
@onready var buildings_limit_upgrade: Label = $Center/CenterContainer/PanelContainer/HBoxContainer/VBoxUpgradeInfo/VBoxUpgrade/BuildingsLimitUpgrade
@onready var area_owned: Label = $Center/CenterContainer/PanelContainer/HBoxContainer/VBoxUpgradeInfo/VBoxOwned/AreaOwned
@onready var before: Label = $Center/CenterContainer/PanelContainer/HBoxContainer/VBoxUpgradeInfo/Before
@onready var after: Label = $Center/CenterContainer/PanelContainer/HBoxContainer/VBoxUpgradeInfo/After
@onready var v_box_upgrade: ItemList = $Center/CenterContainer/PanelContainer/HBoxContainer/VBoxUpgradeInfo/VBoxUpgrade
@onready var v_box_maximum_level: ItemList = $Center/CenterContainer/PanelContainer/HBoxContainer/VBoxUpgradeInfo/VBoxMaximumLevel
@onready var button_upgrade: SoundButton = $Center/CenterContainer/PanelContainer/HBoxContainer/VBoxInfo/ButtonUpgrade
@onready var label: Label = $Center/CenterContainer/PanelContainer/HBoxContainer/VBoxOwned/Label
@onready var gold_cost_label: Label = $Center/CenterContainer/PanelContainer/HBoxContainer/VBoxInfo/HBoxCostInfo/VBoxContainer/HBoxGold/GoldCost
@onready var wood_cost_label: Label = $Center/CenterContainer/PanelContainer/HBoxContainer/VBoxInfo/HBoxCostInfo/VBoxContainer/HBoxWood/WoodCost
@onready var stone_cost_label: Label = $Center/CenterContainer/PanelContainer/HBoxContainer/VBoxInfo/HBoxCostInfo/VBoxContainer/HBoxStone/StoneCost
@onready var steel_cost_label: Label = $Center/CenterContainer/PanelContainer/HBoxContainer/VBoxInfo/HBoxCostInfo/VBoxContainer2/HBoxContainer/SteelCost
@onready var food_cost_label: Label = $Center/CenterContainer/PanelContainer/HBoxContainer/VBoxInfo/HBoxCostInfo/VBoxContainer2/HBoxContainer2/FoodCost
@onready var description_label: Label = $Center/CenterContainer/PanelContainer/HBoxContainer/VBoxInfo/Description
@onready var city_fog_disperser: CityFogDisperser = $CityFogDisperser

var village: CompressedTexture2D = load("res://img/buildings/farm.png") as CompressedTexture2D
var town: CompressedTexture2D = load("res://img/buildings/town_hall.png") as CompressedTexture2D

var city:City
var selected_building:BuildingBaseClass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if city.city_level == 0:
		first_upgrade_info()
		
	elif city.city_level == 1:
		second_upgrade_info()
	
	elif city.city_level == 2:
		button_upgrade.disabled = true
	
func _display_building_info(gold_cost: int, wood_cost: int, stone_cost: int, steel_cost: int, food_cost: int)->void:
	gold_cost_label.text=str(gold_cost)
	wood_cost_label.text=str(wood_cost)
	stone_cost_label.text=str(stone_cost)
	steel_cost_label.text=str(steel_cost)
	food_cost_label.text=str(food_cost)
	
func first_upgrade_info() -> void:
	before.text = "Level 1: Village"
	after.text = "Level 2: Town"
	area_owned.text = "Area Size: " + str(city.city_radius)
	buildings_limit_owned.text = "Buildings Limit: " + str(city.building_limit)
	area_upgrade.text = "Area Size: " + str(city.city_radius + 2)
	buildings_limit_upgrade.text = "Buildings Limit: " + str(city.building_limit + 2)	
	_display_building_info(10,2,2,2,2)
	description_label.text = "Your city radius and building limit will increase by 2"
	
	if (city.city_owner.gold >= 10 and city.city_owner.wood >= 2 and 
	city.city_owner.stone >= 2 and city.city_owner.steel >= 2 and city.city_owner.food >= 2):
		button_upgrade.disabled = false
		
	else:
		button_upgrade.disabled = true
	
	
	
func first_upgrade_upgrade() -> void:
	city.city_level+=1
	city.city_radius+=2
	city.building_limit+=2
	city.fog_disperser.set_radius(city.city_radius)
	upgrade_cost(10,2,2,2,2)
	city.texture = village
	
func second_upgrade_info() -> void:
	before.text = "Level 2: Town"
	after.text = "Level 3: City"
	area_owned.text = "Area Size: " + str(city.city_radius)
	buildings_limit_owned.text = "Buildings Limit: " + str(city.building_limit)
	area_upgrade.text = "Area Size: " + str(city.city_radius + 3)
	buildings_limit_upgrade.text = "Buildings Limit: " + str(city.building_limit + 3)	
	
	_display_building_info(20,4,4,4,4)
	description_label.text = "Your city radius and building limit will increase by 3"
	
	if (city.city_owner.gold >= 20 and city.city_owner.wood >= 4 and 
	city.city_owner.stone >= 4 and city.city_owner.steel >= 4 and city.city_owner.food >= 4):
		button_upgrade.disabled = false
		
	else:
		button_upgrade.disabled = true
	
func second_upgrade_upgrade() -> void:
	city.city_level+=1
	city.city_radius+=3
	city.building_limit+=3
	city.fog_disperser.set_radius(city.city_radius)
	upgrade_cost(20,4,4,4,4)
	city.texture = town

func third_upgrade_info() -> void:
	after.visible = false
	v_box_upgrade.visible = false
	v_box_maximum_level.visible = true
	before.text = "Level 3: City"
	area_owned.text = "Area Size: " + str(city.city_radius)
	buildings_limit_owned.text = "Buildings Limit: " + str(city.building_limit)
	description_label.text = ""
	_display_building_info(0,0,0,0,0)

func _on_exit_button_pressed() -> void:
	city.update_city_info()
	get_tree().paused=false
	queue_free()


func _on_button_upgrade_pressed() -> void:
	if city.city_level == 0:
		first_upgrade_upgrade()
		second_upgrade_info()
		
	elif city.city_level == 1:
		second_upgrade_upgrade()
		third_upgrade_info()
		button_upgrade.disabled = true

func upgrade_cost(gold_cost: int, wood_cost: int, stone_cost: int, steel_cost: int, food_cost: int):
	city.city_owner.gold-=gold_cost
	city.city_owner.wood-=wood_cost
	city.city_owner.stone-=stone_cost
	city.city_owner.steel-=steel_cost
	city.city_owner.food-=food_cost

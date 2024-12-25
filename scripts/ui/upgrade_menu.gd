extends Control
@onready var area_owned: Label = $Center/CenterContainer/PanelContainer/HBoxContainer/VBoxOwned/VBoxContainer2/AreaOwned
@onready var buildings_limit_owned: Label = $Center/CenterContainer/PanelContainer/HBoxContainer/VBoxOwned/VBoxContainer2/BuildingsLimitOwned
@onready var area_upgrade: Label = $Center/CenterContainer/PanelContainer/HBoxContainer/VBoxOwned/VBoxContainer/AreaUpgrade
@onready var buildings_limit_upgrade: Label = $Center/CenterContainer/PanelContainer/HBoxContainer/VBoxOwned/VBoxContainer/BuildingsLimitUpgrade

var city:City
var selected_building:BuildingBaseClass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if city.city_level == 0:
		first_upgrade_info()
		
	elif city.city_level == 1:
		second_upgrade_info()
	
	
func first_upgrade_info() -> void:
	area_owned.text = "Area Size: " + str(city.city_radius)
	buildings_limit_owned.text = "Buildings Limit: " + str(city.building_limit)
	area_upgrade.text = "Area Size: " + str(city.city_radius + 2)
	buildings_limit_upgrade.text = "Buildings Limit: " + str(city.building_limit + 2)	
	
func first_upgrade_upgrade() -> void:
	city.city_level+=1
	city.city_radius+=2
	city.building_limit+=2
	
func second_upgrade_info() -> void:
	area_owned.text = "Area Size: " + str(city.city_radius)
	buildings_limit_owned.text = "Buildings Limit: " + str(city.building_limit)
	area_upgrade.text = "Area Size: " + str(city.city_radius + 3)
	buildings_limit_upgrade.text = "Buildings Limit: " + str(city.building_limit + 3)	
	
func second_upgrade_upgrade() -> void:
	city.city_level+=1
	city.city_radius+=3
	city.building_limit+=3
	
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
		second_upgrade_info()

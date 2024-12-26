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
	
func first_upgrade_info() -> void:
	before.text = "Level 1: Village"
	after.text = "Level 2: Town"
	area_owned.text = "Area Size: " + str(city.city_radius)
	buildings_limit_owned.text = "Buildings Limit: " + str(city.building_limit)
	area_upgrade.text = "Area Size: " + str(city.city_radius + 2)
	buildings_limit_upgrade.text = "Buildings Limit: " + str(city.building_limit + 2)	
	
func first_upgrade_upgrade() -> void:
	city.city_level+=1
	city.city_radius+=2
	city.building_limit+=2
	
func second_upgrade_info() -> void:
	before.text = "Level 2: Town"
	after.text = "Level 3: City"
	area_owned.text = "Area Size: " + str(city.city_radius)
	buildings_limit_owned.text = "Buildings Limit: " + str(city.building_limit)
	area_upgrade.text = "Area Size: " + str(city.city_radius + 3)
	buildings_limit_upgrade.text = "Buildings Limit: " + str(city.building_limit + 3)	
	
func second_upgrade_upgrade() -> void:
	city.city_level+=1
	city.city_radius+=3
	city.building_limit+=3

func third_upgrade_info() -> void:
	after.visible = false
	v_box_upgrade.visible = false
	v_box_maximum_level.visible = true
	before.text = "Level 3: City"
	area_owned.text = "Area Size: " + str(city.city_radius)
	buildings_limit_owned.text = "Buildings Limit: " + str(city.building_limit)

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

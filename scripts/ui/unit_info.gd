extends Control
class_name UnitInfo
## Displays information about a unit

var unit_name:String="Unit"
var health:int=100
var defense:int=100
var attack:int=100

static func get_unit_info_window(u_name:String, health_p:int, defense_p:int, attack_p:int):
	var unit_info:UnitInfo=load("res://scenes/ui/unit_info.tscn").instantiate()
	unit_info.unit_name=u_name
	unit_info.health=health_p
	unit_info.defense=defense_p
	unit_info.attack=attack_p
	
	return unit_info

func _ready() -> void:
	$HBoxContainer/VBoxContainer/LabelName.text=unit_name
	$HBoxContainer/VBoxContainer/HBoxHealth/Label.text=str(health)
	$HBoxContainer/VBoxContainer/HBoxDefense/Label.text=str(defense)
	$HBoxContainer/VBoxContainer/HBoxAttack/Label.text=str(attack)

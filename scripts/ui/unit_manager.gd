extends Node

var units: Array[BaseUnit] = [
	preload("res://scenes/Units/Archer.tscn").instantiate(),
	preload("res://scenes/Units/ArchMage.tscn").instantiate(),
	preload("res://scenes/Units/Cavalry.tscn").instantiate(),
	preload("res://scenes/Units/Crossbowman.tscn").instantiate(),
	preload("res://scenes/Units/Halberdman.tscn").instantiate(),
	preload("res://scenes/Units/Mage.tscn").instantiate(),
	preload("res://scenes/Units/Scout.tscn").instantiate(),
	preload("res://scenes/Units/Shieldman.tscn").instantiate(),
	preload("res://scenes/Units/Spearman.tscn").instantiate(),
	preload("res://scenes/Units/Warrior.tscn").instantiate()
]

var unit:BaseUnit
var city: City

func get_unit_cost(unit:BaseUnit) -> Dictionary:
	return {"gold": unit.cost_gold, "food": unit.cost_food}
	
func can_player_afford_unit(cost:Dictionary) -> bool:
	if city == null:
		return false
	if city.city_owner == null:
		return false
	var player = city.city_owner
	if(player.gold >= cost["gold"] and player.food >= cost["food"]):
		return true
	else:
		return false

func can_player_recruit_unit(unit:BaseUnit) -> bool:
	if(can_player_afford_unit(get_unit_cost(unit))):
		return true
	return false

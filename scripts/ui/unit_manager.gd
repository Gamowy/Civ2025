extends Node

@onready var unitlayer: UnitLayer = get_node("/root/Main/Map/UnitLayer")

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

func recruit_unit(unit:BaseUnit):
	var target_position = unitlayer.pos_clicked + Vector2i(1,-1)
	unitlayer.pos_clicked = target_position
	if unitlayer.is_cell_free(unitlayer.pos_clicked):
		if(unit.unit_name == "Archer"):
			unitlayer.spawn_archer()
		elif(unit.unit_name == "Arch Mage"):
			unitlayer.spawn_archmage()
		elif(unit.unit_name == "Cavalry"):
			unitlayer.spawn_cavalry()
		elif(unit.unit_name == "Crossbowman"):
			unitlayer.spawn_crossbowman()
		elif(unit.unit_name == "Halberdman"):
			unitlayer.spawn_halberdman()
		elif(unit.unit_name == "Mage"):
			unitlayer.spawn_mage()
		elif(unit.unit_name == "Scout"):
			unitlayer.spawn_scout()
		elif(unit.unit_name == "Shieldman"):
			unitlayer.spawn_shieldman()
		elif(unit.unit_name == "Spearman"):
			unitlayer.spawn_spearman()
		elif(unit.unit_name == "Warrrior"):
			unitlayer.spawn_warrior()
	expenses(unit)
	unitlayer.pos_clicked = target_position - Vector2i(1,-1)

func expenses(unit:BaseUnit):
	var cost:Dictionary = get_unit_cost(unit)
	city.city_owner.gold -= cost["gold"]
	city.city_owner.food -= cost["food"]

extends Node

var buildings:Array[BuildingBaseClass]=[
	preload("res://scenes/buildings/mill.tscn").instantiate(),
	preload("res://scenes/buildings/forester.tscn").instantiate(),
	preload("res://scenes/buildings/quarry.tscn").instantiate(),
	preload("res://scenes/buildings/blacksmith.tscn").instantiate(),
	preload("res://scenes/buildings/marketplace.tscn").instantiate(),
	preload("res://scenes/buildings/farm.tscn").instantiate(),
	preload("res://scenes/buildings/sawmill.tscn").instantiate(),
	preload("res://scenes/buildings/mine.tscn").instantiate(),
	preload("res://scenes/buildings/ironworks.tscn").instantiate(),
	preload("res://scenes/buildings/town_hall.tscn").instantiate()
	]

var city:City

# removes given building from city's buildings
func destroy_building(building:BuildingBaseClass):
	var building_to_remove_index:int=city.buildings.find(building)
	if building_to_remove_index!=-1:
		city.buildings.remove_at(building_to_remove_index)

# adds given building to city's buildings
func build_building(building:BuildingBaseClass):
	var cost:Dictionary=get_building_cost_dict(building)
	city.city_owner.gold-=cost["gold"]
	city.city_owner.wood-=cost["wood"]
	city.city_owner.stone-=cost["stone"]
	city.city_owner.steel-=cost["steel"]
	city.city_owner.food-=cost["food"]
	city.buildings.append(building)
	city.update_city_menu_info()

#checks if player can build a building
func can_player_build_building(building:BuildingBaseClass)->bool:
	if can_player_afford_building(get_building_cost_dict(building)):
		if len(city.buildings)<city.building_limit:#check if city can have more buildings
			return true
	return false

# checks if player has enough resources to build building
func can_player_afford_building(cost:Dictionary)->bool:
	if city==null:
		return false
	if city.city_owner==null:
		return false
	var player:Player=city.city_owner
	if (player.gold>=cost["gold"] and player.wood>=cost["wood"] and player.stone>=cost["stone"] and
		player.steel>=cost["steel"] and player.food>=cost["food"]):
		return true
	else:
		return false

# returns cost of building in dictionary form
func get_building_cost_dict(building:BuildingBaseClass)->Dictionary:
	return {"gold":building.gold_cost,"wood":building.wood_cost,
	"stone":building.stone_cost,"steel":building.steel_cost,"food":building.food_cost}

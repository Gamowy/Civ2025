extends BuildingBaseClass

@export_category("Mine")
## How many units of stone the mine produces per turn
@export var stone_production:int=15

func grant_boon(building_city:City)->void:
	building_city.city_owner.stone+=stone_production

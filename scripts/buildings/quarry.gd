extends BuildingBaseClass

@export_category("Quarry")
## How many units of stone the quarry produces per turn
@export var stone_production:int=5

func grant_boon(building_city:City)->void:
	building_city.city_owner.stone+=stone_production

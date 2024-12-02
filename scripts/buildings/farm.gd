extends BuildingBaseClass

@export_category("Farm")
## How many units of food the farm produces per turn
@export var food_production:int=15

func grant_boon(building_city:City)->void:
	building_city.city_owner.food+=food_production

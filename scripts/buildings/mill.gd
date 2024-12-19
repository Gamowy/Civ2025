extends BuildingBaseClass

@export_category("Mill")
## How many units of food the mill produces per turn
@export var food_production:int=5

func grant_boon(building_city:City)->void:
	building_city.city_owner.food+=food_production

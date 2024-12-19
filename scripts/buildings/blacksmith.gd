extends BuildingBaseClass

@export_category("Blacksmith")
## How many units of steel the blacksmith produces per turn
@export var steel_production:int=5

func grant_boon(building_city:City)->void:
	building_city.city_owner.steel+=steel_production

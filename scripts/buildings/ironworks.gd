extends BuildingBaseClass

@export_category("Ironworks")
## How many units of steel the ironworks produces per turn
@export var steel_production:int=15

func grant_boon(building_city:City)->void:
	building_city.city_owner.steel+=steel_production

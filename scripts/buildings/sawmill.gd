extends BuildingBaseClass

@export_category("Sawmill")
## How many units of wood the sawmill produces per turn
@export var wood_production:int=15

func grant_boon(building_city:City)->void:
	building_city.city_owner.wood+=wood_production

extends BuildingBaseClass

@export_category("Forester")
## How many units of wood the forester produces per turn
@export var wood_production:int=5

func grant_boon(building_city:City)->void:
	building_city.city_owner.wood+=wood_production

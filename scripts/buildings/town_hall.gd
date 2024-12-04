extends BuildingBaseClass

@export_category("Town Hall")
## How many units of gold the town hall produces per turn
@export var gold_production:int=15

func grant_boon(building_city:City)->void:
	building_city.city_owner.gold+=gold_production

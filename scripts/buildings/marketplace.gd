extends BuildingBaseClass

@export_category("Marketplace")
## How many units of gold the marketplace produces per turn
@export var gold_production:int=5

func grant_boon(building_city:City)->void:
	building_city.city_owner.gold+=gold_production

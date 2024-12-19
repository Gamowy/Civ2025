extends BuildingBaseClass
class_name resource_granting_building

func grant_boon(building_city:City)->void:
	building_city.city_owner.gold += gold_production
	building_city.city_owner.wood += wood_production
	building_city.city_owner.stone += stone_production
	building_city.city_owner.steel += steel_production
	building_city.city_owner.food += food_production
	

extends ProgressBar
class_name HealthBar

static func create_healthbar(owner,health:int,max_health:int):
	var healthbar:HealthBar=load("res://scenes/Units/unit_elements/unit_healthbar.tscn").instantiate()
	healthbar.max_value=max_health
	healthbar.value=health
	owner.add_child(healthbar)
	owner.health_updated.connect(healthbar.update_health_bar)
	return healthbar

func update_health_bar(hp:int):
	value=hp

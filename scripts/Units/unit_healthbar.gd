extends ProgressBar
class_name HealthBar

static func create_healthbar(owner:BaseUnit,health:int,max_health:int):
	var healthbar:HealthBar=load("res://scenes/Units/unit_healthbar.tscn").instantiate()
	healthbar.max_value=max_health
	healthbar.value=health
	owner.add_child(healthbar)
	owner.health_updated.connect(healthbar.update_health_bar)
	return healthbar

func update_health_bar(hp:int):
	value=hp

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

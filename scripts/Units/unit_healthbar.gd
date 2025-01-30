extends ProgressBar
class_name HealthBar

var green_healthbar = StyleBoxFlat.new()
var yellow_healthbar = StyleBoxFlat.new()
var red_healthbar = StyleBoxFlat.new()

func _ready():
	green_healthbar.bg_color = Color.GREEN
	yellow_healthbar.bg_color = Color.YELLOW
	red_healthbar.bg_color = Color.RED

static func create_healthbar(health_owner,health:int,max_health:int):
	var healthbar:HealthBar=load("res://scenes/Units/unit_elements/unit_healthbar.tscn").instantiate()
	healthbar.max_value=max_health
	healthbar.value=health
	health_owner.add_child(healthbar)
	health_owner.health_updated.connect(healthbar.update_health_bar)
	return healthbar

func update_health_bar(hp:int):
	value=hp
	if value < max_value/3:
		set("theme_override_styles/fill", red_healthbar)
	elif value < max_value/2:
		set("theme_override_styles/fill", yellow_healthbar)
	else:
		set("theme_override_styles/fill", green_healthbar)

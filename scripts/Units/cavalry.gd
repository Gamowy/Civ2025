extends BaseUnit


# Called when the node enters the scene tree for the first time.
func _ready():
	unit_name = "Cavalry"
	health = 150
	@warning_ignore("integer_division")
	attack = 15 * (health/150)
	defense = 8
	movementRange = 4
	rangeOfView = 3
	cost_gold = 4
	cost_food = 4
	sprite = $AnimatedSprite2D
	if has_node("UnitFogDisperser"):
		$UnitFogDisperser.refresh_radius_from_owner()

extends BaseUnit


# Called when the node enters the scene tree for the first time.
func _ready():
	unit_name = "Shieldman"
	health = 150
	@warning_ignore("integer_division")
	attack = 10 * (health/150)
	defense = 12
	movementRange = 3
	rangeOfView = 3
	cost_gold = 3
	cost_food = 1
	sprite = $AnimatedSprite2D
	if has_node("UnitFogDisperser"):
		$UnitFogDisperser.refresh_radius_from_owner()

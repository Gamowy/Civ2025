extends BaseUnit


# Called when the node enters the scene tree for the first time.
func _ready():
	unit_name = "Mage"
	health = 50
	@warning_ignore("integer_division")
	attack = 25 * (health/50)
	defense = 3
	movementRange = 2
	rangeOfView = 3
	cost_gold = 4
	cost_food = 3
	sprite = $AnimatedSprite2D
	if has_node("UnitFogDisperser"):
		$UnitFogDisperser.refresh_radius_from_owner()

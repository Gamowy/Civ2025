extends BaseUnit


# Called when the node enters the scene tree for the first time.
func _ready():
	unit_name = "Halberdman"
	health = 130
	@warning_ignore("integer_division")
	attack = 14 * (health/130)
	defense = 9
	movementRange = 3
	rangeOfView = 3
	cost_gold = 2
	cost_food = 3
	sprite = $AnimatedSprite2D
	description = "Couldn't decide if wanted an axe or a spear, instead opted for both."
	if has_node("UnitFogDisperser"):
		$UnitFogDisperser.refresh_radius_from_owner()

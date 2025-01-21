extends BaseUnit


# Called when the node enters the scene tree for the first time.
func _ready():
	unit_name = "Arch Mage"
	health = 60
	@warning_ignore("integer_division")
	attack = 30 * (health/50)
	defense = 5
	movementRange = 2
	rangeOfView = 4
	cost_gold = 5
	cost_food = 4
	sprite = $AnimatedSprite2D
	description = "Dedicated his whole life to creating handheld atomic bombs (failed, but got fireballs instead)."
	if has_node("UnitFogDisperser"):
		$UnitFogDisperser.refresh_radius_from_owner()

extends BaseUnit


# Called when the node enters the scene tree for the first time.
func _ready():
	unit_name = "Archer"
	health = 70
	@warning_ignore("integer_division")
	attack = 18 * (health/70)
	defense = 3
	movementRange = 3
	rangeOfView = 3
	cost_gold = 2
	cost_food = 2
	sprite = $AnimatedSprite2D
	description = "He shoots arrows with the strength of a thousand suns. Ocasionally, when out of ammo, he throws a bow."
	#super._ready()
	if has_node("UnitFogDisperser"):
		$UnitFogDisperser.refresh_radius_from_owner()

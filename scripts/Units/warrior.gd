extends BaseUnit



func _ready():
	unit_name = "Warrior"
	health = 120
	max_health=health
	@warning_ignore("integer_division")
	attack = 10 * (health/120)
	defense = 8
	movementRange = 3
	rangeOfView = 2
	cost_gold = 2
	cost_food = 1
	sprite = $AnimatedSprite2D
	description = "He's got a sword and a dream."
	#super._ready()
	if has_node("UnitFogDisperser"):
		$UnitFogDisperser.refresh_radius_from_owner()
	super._ready()

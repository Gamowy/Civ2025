extends BaseUnit


# Called when the node enters the scene tree for the first time.
func _ready():
	unit_name = "Crossbowman"
	health = 80
	max_health=health
	@warning_ignore("integer_division")
	attack = 22 * (health/80)
	defense = 4
	movementRange = 3
	rangeOfView = 3
	cost_gold = 3
	cost_food = 3
	sprite = $AnimatedSprite2D
	description = "Somewhat like a lazy dev, too weak to pull a bow so invents a contraption to do it for him."
	if has_node("UnitFogDisperser"):
		$UnitFogDisperser.refresh_radius_from_owner()
	super._ready()

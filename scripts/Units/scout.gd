extends BaseUnit


# Called when the node enters the scene tree for the first time.

func _ready():
	unit_name = "Scout"
	health = 100
	max_health=health
	@warning_ignore("integer_division")
	attack = 5 * (health/100) 
	defense = 5
	movementRange = 5
	rangeOfView = 4
	cost_gold = 1
	cost_food = 1
	sprite = $AnimatedSprite2D
	description = "When deciding on a movement range this man just said 'yes'."
	if has_node("UnitFogDisperser"):
		$UnitFogDisperser.refresh_radius_from_owner()
	super._ready()

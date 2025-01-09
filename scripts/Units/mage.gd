extends BaseUnit


# Called when the node enters the scene tree for the first time.
func _ready():
	health = 50
	@warning_ignore("integer_division")
	attack = 25 * (health/50)
	defense = 3
	movementRange = 2
	rangeOfView = 3
	
	if has_node("UnitFogDisperser"):
		$UnitFogDisperser.refresh_radius_from_owner()

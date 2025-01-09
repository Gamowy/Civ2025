extends BaseUnit


# Called when the node enters the scene tree for the first time.
func _ready():
	health = 80
	@warning_ignore("integer_division")
	attack = 22 * (health/80)
	defense = 4
	movementRange = 3
	rangeOfView = 3
	
	if has_node("UnitFogDisperser"):
		$UnitFogDisperser.refresh_radius_from_owner()

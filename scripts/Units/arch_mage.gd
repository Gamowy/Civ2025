extends BaseUnit


# Called when the node enters the scene tree for the first time.
func _ready():
	health = 60
	@warning_ignore("integer_division")
	attack = 30 * (health/50)
	defense = 5
	movementRange = 2
	rangeOfView = 4
	
	if has_node("UnitFogDisperser"):
		$UnitFogDisperser.refresh_radius_from_owner()

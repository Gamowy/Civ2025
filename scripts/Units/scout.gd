extends BaseUnit


# Called when the node enters the scene tree for the first time.

func _ready():
	health = 100
	@warning_ignore("integer_division")
	attack = 5 * (health/100) 
	defense = 5
	movementRange = 5
	rangeOfView = 4
	
	if has_node("UnitFogDisperser"):
		$UnitFogDisperser.refresh_radius_from_owner()

extends BaseUnit



func _ready():
	health = 120
	@warning_ignore("integer_division")
	attack = 10 * (health/120)
	defense = 8
	movementRange = 3
	rangeOfView = 2
	#super._ready()
	if has_node("UnitFogDisperser"):
		$UnitFogDisperser.refresh_radius_from_owner()

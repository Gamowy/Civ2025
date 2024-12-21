extends BaseUnit



func _ready():
	health = 120
	@warning_ignore("integer_division")
	attack = 10 * (health/120)
	defense = 8
	movementRange = 3
	rangeOfView = 3
	#super._ready()

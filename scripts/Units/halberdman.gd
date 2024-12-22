extends BaseUnit


# Called when the node enters the scene tree for the first time.
func _ready():
	health = 130
	@warning_ignore("integer_division")
	attack = 14 * (health/130)
	defense = 9
	movementRange = 3
	rangeOfView = 3

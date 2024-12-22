extends BaseUnit


# Called when the node enters the scene tree for the first time.
func _ready():
	health = 150
	@warning_ignore("integer_division")
	attack = 10 * (health/150)
	defense = 12
	movementRange = 3
	rangeOfView = 3

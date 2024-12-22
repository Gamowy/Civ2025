extends BaseUnit


# Called when the node enters the scene tree for the first time.
func _ready():
	health = 150
	@warning_ignore("integer_division")
	attack = 15 * (health/150)
	defense = 8
	movementRange = 4
	rangeOfView = 3

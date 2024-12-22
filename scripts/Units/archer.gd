extends BaseUnit


# Called when the node enters the scene tree for the first time.
func _ready():
	health = 70
	@warning_ignore("integer_division")
	attack = 18 * (health/70)
	defense = 3
	movementRange = 3
	rangeOfView = 3

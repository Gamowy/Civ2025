extends BaseUnit


# Called when the node enters the scene tree for the first time.
func _ready():
	health = 110
	@warning_ignore("integer_division")
	attack = 12 * (health/110)
	defense = 7
	movementRange = 3
	rangeOfView = 3


# Called every frame. 'delta' is the elapsed time since the previous frame.

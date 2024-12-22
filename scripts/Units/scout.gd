extends BaseUnit


# Called when the node enters the scene tree for the first time.
func _ready():
	health = 100
	attack = 5 * (health/100)
	defense = 5
	movementRange = 5
	rangeOfView = 4

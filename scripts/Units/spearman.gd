extends BaseUnit


# Called when the node enters the scene tree for the first time.
func _ready():
	unit_name = "Spearman"
	health = 110
	@warning_ignore("integer_division")
	attack = 12 * (health/110)
	defense = 7
	movementRange = 3
	rangeOfView = 3
	cost_gold = 1
	cost_food = 2
	sprite = $AnimatedSprite2D
	if has_node("UnitFogDisperser"):
		$UnitFogDisperser.refresh_radius_from_owner()


# Called every frame. 'delta' is the elapsed time since the previous frame.

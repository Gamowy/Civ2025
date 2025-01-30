extends BaseUnit


# Called when the node enters the scene tree for the first time.
func _ready():
	unit_name = "Spearman"
	health = 110
	max_health=health
	@warning_ignore("integer_division")
	attack = 12 * (health/110)
	defense = 7
	movementRange = 3
	rangeOfView = 3
	cost_gold = 1
	cost_food = 2
	sprite = $AnimatedSprite2D
	description = "Likes stabbing people but dagger was too short."
	if has_node("UnitFogDisperser"):
		$UnitFogDisperser.refresh_radius_from_owner()
	super._ready()


# Called every frame. 'delta' is the elapsed time since the previous frame.

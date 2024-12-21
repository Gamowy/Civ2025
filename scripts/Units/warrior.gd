extends "res://Scripts/Units/base_unit.gd"



func _ready():
	health = 120
	attack = 10 * (health/120)
	defense = 8
	movementRange = 3
	rangeOfView = 3
	
	super._ready()

extends Node2D
class_name BaseUnit

var health: int = 100
var attack: int = 5
var defense: int = 5
var movementRange: int = 2
var rangeOfView: int = 2

var ownerID: int = -1

@onready var sprite: AnimatedSprite2D=$AnimatedSprite2D



func takeDamage(damage: int):
	var damageTaken = max(damage - defense,0)
	health -= damageTaken
	if health <= 0:
		die()

func die():
	queue_free()

extends Node2D

var health: int = 100
var attack: int = 5
var defense: int = 5
var movementRange: int = 2
var rangeOfView: int = 2

var ownerID: int = -1

var sprite: Sprite2D
# Called when the node enters the scene tree for the first time.
func _ready():
	sprite = $Sprite


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func takeDamage(damage: int):
	var damageTaken = max(damage - defense,0)
	health -= damageTaken
	if health <= 0:
		die()

func die():
	queue_free()

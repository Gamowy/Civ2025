extends Node2D
class_name BaseUnit

var health: int = 100
var attack: int = 5
var defense: int = 5
var movementRange: int = 2
var rangeOfView: int = 2

var ownerID: int = -1

@onready var sprite: AnimatedSprite2D=$AnimatedSprite2D

#Unit movement
func move_to(target_position: Vector2, unit_layer: TileMapLayer) -> bool:
	var hex_coords = unit_layer.local_to_map(position)
	var distance = hex_coords.distance_to(target_position)
	
	#Checking if there is no obstacle and if unit can move there
	if distance <= movementRange and unit_layer.is_cell_free(target_position):
		position = unit_layer.map_to_local(target_position)
		return true
		
	return false
		

func takeDamage(damage: int):
	var damageTaken = max(damage - defense,0)
	health -= damageTaken
	if health <= 0:
		die()

func die():
	queue_free()

extends Node2D
class_name BaseUnit

var health: int = 100
var attack: int = 5
var defense: int = 5
var movementRange: int = 2
var rangeOfView: int = 2

var ownerID: int = -1

@onready var sprite: AnimatedSprite2D=$AnimatedSprite2D
@onready var map_layer: TileMapLayer =get_tree().get_first_node_in_group("map_layer")

## The unit's fog disperser
@export var fog_dispenser_scene:UnitFogDisperser


#Unit movement
func move_to(target_hex: Vector2, unit_layer: TileMapLayer) -> bool:
	var target_position = unit_layer.map_to_local(target_hex)
	var hex_coords = unit_layer.local_to_map(position)
	#var custom_range = unit_layer.get_tile_cost(hex_coords)
	var distance = hex_coords.distance_to(target_hex)
	var move_time = distance
	#Checking if there is no obstacle and if unit can move there
	if distance <= movementRange and unit_layer.is_cell_free(target_hex):
		var tween = create_tween()
		#position = unit_layer.map_to_local(target_position)
		if target_position.x < position.x:
			sprite.flip_h = true
		else:
			sprite.flip_h = false
		
		sprite.play("Walk")
		tween.tween_property(self,"position",unit_layer.map_to_local(target_hex), move_time)
		tween.finished.connect(func():
			sprite.play("Idle")
			)
		return true
		
	return false
		

func takeDamage(damage: int):
	var damageTaken = max(damage - defense,0)
	health -= damageTaken
	if health <= 0:
		die()

func die():
	queue_free()

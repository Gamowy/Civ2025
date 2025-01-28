extends Node2D
class_name BaseUnit

var unit_name:String = "Base Unit"
var health: int = 100
var attack: int = 5
var defense: int = 5
var movementRange: int = 2
var rangeOfView: int = 2
var cost_gold:int = 1
var cost_food:int = 1
var description:String = "lorem ipsum"

var unit_owner: Player

@onready var sprite: AnimatedSprite2D=$AnimatedSprite2D
@onready var map_layer: TileMapLayer =get_tree().get_first_node_in_group("map_layer")

## The unit's fog disperser
@export var fog_dispenser_scene:UnitFogDisperser

#Unit movement
func move_to(target_hex: Vector2, unit_layer: TileMapLayer) -> bool:
	var tile = map_layer.terrain_dict.find_key(map_layer.get_cell_atlas_coords(target_hex))
	var empty = map_layer.terrain_dict.find_key(map_layer.get_cell_atlas_coords(Vector2(-4,-4)))
	print(tile)
	print(empty)
	var target_position = unit_layer.map_to_local(target_hex)
	var hex_coords = unit_layer.local_to_map(position)
	#var custom_range = unit_layer.get_tile_cost(hex_coords)
	var distance = hex_coords.distance_to(target_hex)
	var move_time = distance
	#Checking if there is no obstacle and if unit can move there
	if distance <= movementRange and unit_layer.is_cell_free(target_hex) and unit_layer.is_cell_not_city(target_hex) and tile != empty:
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

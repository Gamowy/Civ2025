extends Node2D
class_name BaseUnit

@export_category("Unit")
@export var unit_name:String = "Base Unit"
@export var health: int = 100
@export var attack: int = 5
@export var defense: int = 5
@export var movementRange: int = 2
@export var rangeOfView: int = 2
@export var cost_gold:int = 1
@export var cost_food:int = 1
@export var description:String = "lorem ipsum"

@export_storage var unit_owner_id: int
@export_storage var unit_coords : Vector2i

@onready var sprite: AnimatedSprite2D=$AnimatedSprite2D
@onready var map_layer: TileMapLayer =get_tree().get_first_node_in_group("map_layer")
@onready var fog_disperser_point_light = $UnitFogDisperser/PointLight2D

## The unit's fog disperser
@onready var fog_dispenser_scene:UnitFogDisperser = $UnitFogDisperser

## Movement sound player
@onready var moving_sound_player: AudioStreamPlayer = $MovementSFXPlayer


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
		moving_sound_player.play()
		tween.tween_property(self,"position",unit_layer.map_to_local(target_hex), move_time)
		tween.finished.connect(func():
			sprite.play("Idle")
			moving_sound_player.stop()
			)
		return true
	return false
		
func takeDamage(damage: int):
	var damageTaken = max(damage - defense,0)
	health -= damageTaken
	if health <= 0:
		die()
		
func set_color(color: Color):
	sprite.material.set("shader_parameter/replace_0", color)
	sprite.material.set("shader_parameter/replace_1", color.darkened(0.5))

func die():
	queue_free()

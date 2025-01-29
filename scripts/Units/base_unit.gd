extends Node2D
class_name BaseUnit

## Emitted when the unit's health changes
signal health_updated(hp:int)
## Emitted when the unit stops moving
signal finished_movement

@export_category("Unit")
@export var unit_name:String = "Base Unit"
@export var max_health:int=100
@export var health: int = 100:
	set(value):
		health=value
		health_updated.emit(health)
	get():
		return health
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

var boat:Sprite2D
var health_bar:HealthBar
var is_moving:bool=false
var is_in_water:bool=false:
	set(value):
		is_in_water=value
		if boat!=null and is_instance_valid(boat):
			boat.visible=is_in_water
	get:
		return is_in_water

func _ready() -> void:
	health_bar=HealthBar.create_healthbar(self,health,max_health)
	boat=load("res://scenes/Units/unit_elements/boat_sprite.tscn").instantiate()
	add_child(boat)
	move_child(boat,0)
	finished_movement.connect(_on_finished_moving)

func _process(_delta: float) -> void:
	if is_moving:
		check_if_unit_is_in_water()

#Unit movement
func move_to(target_hex: Vector2, unit_layer: UnitLayer) -> bool:
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
		is_moving=true
		tween.finished.connect(func():
			sprite.play("Idle")
			)
		tween.finished.connect(finished_movement.emit)
		await tween.finished
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

func check_if_unit_is_in_water()->bool:
	if map_layer.terrain_dict.find_key(map_layer.get_cell_atlas_coords(map_layer.local_to_map(position)))=="ocean":
		if is_in_water==false:
			is_in_water=true
			print("unit in water")
	elif is_in_water:
		is_in_water=false
		print("unit not in water")
	return is_in_water

func _on_finished_moving():
	is_moving=false

func die():
	queue_free()

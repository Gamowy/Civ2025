extends TileMapLayer
class_name UnitLayer

var global_clicked #= Vector2(0,0)
var pos_clicked # = Vector2(0,0)
@onready var selected_unit: BaseUnit = null
@onready var highlight_layer: TileMapLayer =$"../HighlightLayer"
@onready var map_layer : TileMapLayer = $"../MapLayer"

var units : Array[BaseUnit] = []

func _ready() -> void:
	child_entered_tree.connect(_unit_added)
	child_exiting_tree.connect(_unit_removed)

## Called every time a new unid is recruited
func _unit_added(unit: BaseUnit) -> void:
	await unit.ready
	units.append(unit)

## Called every time a unit is removed
func _unit_removed(unit: BaseUnit) -> void:
	units.erase(unit)
	
## Use this to add already created unit from within code
func add_existing_unit(new_unit: BaseUnit) -> void:
	add_child(new_unit)
	
## Use this to remove all units (used when loading save)
func clear_cities() -> void:
	for unit in self.get_children():
		remove_child(unit)
		unit.queue_free()
		
## Called when switching turns to switch for units
func switch_unit_fog(currentPlayer: Player) -> void:
	for unit in units:
		if unit.unit_owner == currentPlayer:
			unit.fog_disperser_point_light.visible = true
		else:
			unit.fog_disperser_point_light.visible = false

func _unhandled_input(event: InputEvent) -> void:
	var current_player = get_tree().get_first_node_in_group("players").current_player
	if event is InputEventScreenTouch:
		global_clicked = get_global_mouse_position()
		if event.is_pressed():
			pos_clicked = local_to_map(to_local(global_clicked))
				
			if selected_unit:
				if selected_unit.move_to(pos_clicked, self):
					print("Unit moved succesfully.")
				selected_unit = null
				clear_highlight()
			else:
				clear_highlight()
				selected_unit = get_unit_at_position(pos_clicked)
				if selected_unit and selected_unit.unit_owner == current_player:
					print("Unit selected!")
					highlight_possible_moves(selected_unit, pos_clicked)


func get_tile_cost(_tile_position: Vector2) -> int:
	var tmp = map_layer.terrain_dict.find_key(map_layer.get_cell_atlas_coords(pos_clicked))
	if tmp == "mountain":
		return 1
	else:
		return selected_unit.movementRange

func highlight_possible_moves(unit: BaseUnit, start_position: Vector2):
	var unit_range = unit.movementRange
	
	#all tiles in range
	for tileX in range(-unit_range, unit_range + 1):
		for tileY in range(-unit_range, unit_range + 1):
			var target_position = start_position + Vector2(tileX,tileY)
			var tile = map_layer.terrain_dict.find_key(map_layer.get_cell_atlas_coords(target_position))
			var empty = map_layer.terrain_dict.find_key(map_layer.get_cell_atlas_coords(Vector2(-4,-4)))
			var tmp = map_layer.terrain_dict.find_key(map_layer.get_cell_atlas_coords(target_position))
			if target_position.distance_to(start_position) <= unit_range and is_cell_free(target_position) and is_cell_not_city(target_position) and tile != empty:
				highlight_layer.set_cell(target_position, 0, Vector2i(0,0), 1)
				if tmp == "mountain":
					highlight_layer.set_cell(target_position, 0, Vector2i(0,0), 2)
				
				#var tile = highlight_layer.get_cell_item(target_position)
				#if tile:
					#tile.modulate(0, 1, 0, 0.5)

func clear_highlight():
	highlight_layer.clear()

func get_unit_at_position(map_position: Vector2) -> BaseUnit:
	var world_position = map_to_local(map_position)
	for unit in get_children():
		if unit is BaseUnit and unit.position.distance_to(world_position) <1.0:
			return unit
	return null
	
func is_cell_free(map_position: Vector2) -> bool:
	return get_unit_at_position(map_position) == null

func get_city_at_position(map_position: Vector2) -> City:
	var world_position = map_to_local(map_position)
	for city in $"../CityLayer".get_children():
		if city is City and city.position.distance_to(world_position) <1.0:
			return city
	return null

func is_cell_not_city(map_position: Vector2) -> bool:
	return get_city_at_position(map_position) == null

func spawn_spearman():
	var current_player: Player = get_tree().get_first_node_in_group("players").current_player
	var spawn_point = pos_clicked
	var world_position = map_to_local(spawn_point)
	var spearman = preload("res://scenes/Units/Spearman.tscn").instantiate()
	add_child(spearman)
	spearman.position = world_position
	spearman.unit_owner = current_player
	spearman.unit_coords = spawn_point
	spearman.set_color(current_player.flag_color)
	
func spawn_archer():
	var current_player: Player = get_tree().get_first_node_in_group("players").current_player
	var spawn_point = pos_clicked
	var world_position = map_to_local(spawn_point)
	var archer = preload("res://scenes/Units/Archer.tscn").instantiate()
	add_child(archer)
	archer.position = world_position
	archer.unit_owner = current_player
	archer.unit_coords = spawn_point
	archer.set_color(current_player.flag_color)
	
func spawn_archmage():
	var current_player: Player = get_tree().get_first_node_in_group("players").current_player
	var spawn_point = pos_clicked
	var world_position = map_to_local(spawn_point)
	var archmage = preload("res://scenes/Units/ArchMage.tscn").instantiate()
	print(archmage.unit_name)
	add_child(archmage)
	archmage.position = world_position
	archmage.unit_owner = current_player
	archmage.unit_coords = spawn_point
	archmage.set_color(current_player.flag_color)
	
func spawn_cavalry():
	var current_player: Player = get_tree().get_first_node_in_group("players").current_player
	var spawn_point = pos_clicked
	var world_position = map_to_local(spawn_point)
	var cavalry = preload("res://scenes/Units/Cavalry.tscn").instantiate()
	add_child(cavalry)
	cavalry.position = world_position
	cavalry.unit_owner = current_player
	cavalry.unit_coords = spawn_point
	cavalry.set_color(current_player.flag_color)
	
func spawn_crossbowman():
	var current_player: Player = get_tree().get_first_node_in_group("players").current_player
	var spawn_point = pos_clicked
	var world_position = map_to_local(spawn_point)
	var crossbowman = preload("res://scenes/Units/Crossbowman.tscn").instantiate()
	add_child(crossbowman)
	crossbowman.position = world_position
	crossbowman.unit_owner = current_player
	crossbowman.unit_coords = spawn_point
	crossbowman.set_color(current_player.flag_color)
	
func spawn_halberdman():
	var current_player: Player = get_tree().get_first_node_in_group("players").current_player
	var spawn_point = pos_clicked
	var world_position = map_to_local(spawn_point)
	var halberdman = preload("res://scenes/Units/Halberdman.tscn").instantiate()
	add_child(halberdman)
	halberdman.position = world_position
	halberdman.unit_owner = current_player
	halberdman.unit_coords = spawn_point
	halberdman.set_color(current_player.flag_color)
	
func spawn_mage():
	var current_player: Player = get_tree().get_first_node_in_group("players").current_player
	var spawn_point = pos_clicked
	var world_position = map_to_local(spawn_point)
	var mage = preload("res://scenes/Units/Mage.tscn").instantiate()
	add_child(mage)
	mage.position = world_position
	mage.unit_owner = current_player
	mage.unit_coords = spawn_point
	mage.set_color(current_player.flag_color)
	
func spawn_scout():
	var current_player: Player = get_tree().get_first_node_in_group("players").current_player
	var spawn_point = pos_clicked
	var world_position = map_to_local(spawn_point)
	var scout = preload("res://scenes/Units/Scout.tscn").instantiate()
	add_child(scout)
	scout.position = world_position
	scout.unit_owner = current_player
	scout.unit_coords = spawn_point
	scout.set_color(current_player.flag_color)
	
func spawn_shieldman():
	var current_player: Player = get_tree().get_first_node_in_group("players").current_player
	var spawn_point = pos_clicked
	var world_position = map_to_local(spawn_point)
	var shieldman = preload("res://scenes/Units/Shieldman.tscn").instantiate()
	add_child(shieldman)
	shieldman.position = world_position
	shieldman.unit_owner = current_player
	shieldman.unit_coords = spawn_point
	shieldman.set_color(current_player.flag_color)
	
func spawn_warrior():
	var current_player: Player = get_tree().get_first_node_in_group("players").current_player
	var spawn_point = pos_clicked
	var world_position = map_to_local(spawn_point)
	var warrior = preload("res://scenes/Units/Warrior.tscn").instantiate()
	add_child(warrior)
	warrior.position = world_position
	warrior.unit_owner = current_player
	warrior.unit_coords = spawn_point
	warrior.set_color(current_player.flag_color)

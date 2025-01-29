extends TileMapLayer
class_name UnitLayer

signal unit_selected(unit_info:UnitInfo)

var global_clicked #= Vector2(0,0)
var pos_clicked # = Vector2(0,0)
@onready var selected_unit: BaseUnit = null
@onready var backup_unit: BaseUnit = null
@onready var highlight_layer: TileMapLayer =$"../HighlightLayer"
@onready var map_layer : MapLayer = $"../MapLayer"

var units : Array[BaseUnit] = []
var unit_info:UnitInfo

## This is stored so we know if any units are currently moving, so we don't allow saving game while ane movement is in progres
var unit_moving = false

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
func add_exisuing_unit(new_unit: BaseUnit) -> void:
	add_child(new_unit)
	
## Use this to remove all units (used when loading save)
func clear_units() -> void:
	for unit in self.get_children():
		remove_child(unit)
		unit.queue_free()
		
## Called when switching turns to switch fog for units
func switch_unit_fog(currentPlayer: Player) -> void:
	for unit in units:
		if unit.unit_owner_id == currentPlayer.player_id:
			unit.fog_disperser_point_light.visible = true
			unit.fog_dispenser_scene.set_fog_disperser_enabled(true)
		else:
			unit.fog_disperser_point_light.visible = false
			unit.fog_dispenser_scene.set_fog_disperser_enabled(false)

func _unhandled_input(event: InputEvent) -> void:
	var current_player_id: int= get_tree().get_first_node_in_group("players").current_player_id
	if event is InputEventScreenTouch:
		global_clicked = get_global_mouse_position()
		if event.is_pressed():
			clear_unit_info()
			clear_highlight()
			pos_clicked = local_to_map(to_local(global_clicked))
				#check if instance is valid to make sure the selected unit still exists
			if is_instance_valid(selected_unit) and selected_unit and selected_unit.unit_owner_id == current_player_id:
				selected_unit.move_to(pos_clicked, self)
				unit_attack(selected_unit,pos_clicked)
				selected_unit = null
			else:
				clear_highlight()
				selected_unit = get_unit_at_position(pos_clicked)
				backup_unit = selected_unit
				unit_attack(selected_unit, pos_clicked)
				if selected_unit!=null and is_instance_valid(selected_unit):
					unit_info=UnitInfo.get_unit_info_window(selected_unit.unit_name,selected_unit.health,selected_unit.defense,selected_unit.attack)
					unit_selected.emit(unit_info)
				if is_instance_valid(selected_unit) and selected_unit and selected_unit.unit_owner_id == current_player_id:
					highlight_possible_moves(selected_unit, pos_clicked)
					highlight_enemy_targets(selected_unit, pos_clicked)


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

func spawn_spearman(restore: bool = false):
	var spearman = preload("res://scenes/Units/Spearman.tscn").instantiate()
	add_child(spearman)
	if(!restore):
		var current_player: Player = get_tree().get_first_node_in_group("players").current_player
		var spawn_point = pos_clicked
		var world_position = map_to_local(spawn_point)
		spearman.position = world_position
		spearman.unit_owner_id = current_player.player_id
		spearman.unit_coords = spawn_point
		spearman.set_color(current_player.flag_color)
		spearman.fog_disperser_point_light.visible = true
		spearman.fog_dispenser_scene.set_fog_disperser_enabled(true)
	spearman.check_if_unit_is_in_water()
	
func spawn_archer(restore: bool = false):
	var archer = preload("res://scenes/Units/Archer.tscn").instantiate()
	add_child(archer)
	if(!restore):
		var current_player: Player = get_tree().get_first_node_in_group("players").current_player
		var spawn_point = pos_clicked
		var world_position = map_to_local(spawn_point)
		archer.position = world_position
		archer.unit_owner_id = current_player.player_id
		archer.unit_coords = spawn_point
		archer.set_color(current_player.flag_color)
		archer.fog_disperser_point_light.visible = true
		archer.fog_dispenser_scene.set_fog_disperser_enabled(true)
	archer.check_if_unit_is_in_water()
	
func spawn_archmage(restore: bool = false):
	var archmage = preload("res://scenes/Units/ArchMage.tscn").instantiate()
	add_child(archmage)
	if(!restore):
		var current_player: Player = get_tree().get_first_node_in_group("players").current_player
		var spawn_point = pos_clicked
		var world_position = map_to_local(spawn_point)
		archmage.position = world_position
		archmage.unit_owner_id = current_player.player_id
		archmage.unit_coords = spawn_point
		archmage.set_color(current_player.flag_color)
		archmage.fog_disperser_point_light.visible = true
		archmage.fog_dispenser_scene.set_fog_disperser_enabled(true)
	archmage.check_if_unit_is_in_water()
		
func spawn_cavalry(restore: bool = false):
	var cavalry = preload("res://scenes/Units/Cavalry.tscn").instantiate()
	add_child(cavalry)
	if(!restore):
		var current_player: Player = get_tree().get_first_node_in_group("players").current_player
		var spawn_point = pos_clicked
		var world_position = map_to_local(spawn_point)
		cavalry.position = world_position
		cavalry.unit_owner_id = current_player.player_id
		cavalry.unit_coords = spawn_point
		cavalry.set_color(current_player.flag_color)
		cavalry.fog_disperser_point_light.visible = true
		cavalry.fog_dispenser_scene.set_fog_disperser_enabled(true)
	cavalry.check_if_unit_is_in_water()
	
func spawn_crossbowman(restore: bool = false):
	var crossbowman = preload("res://scenes/Units/Crossbowman.tscn").instantiate()
	add_child(crossbowman)
	if(!restore):
		var current_player: Player = get_tree().get_first_node_in_group("players").current_player
		var spawn_point = pos_clicked
		var world_position = map_to_local(spawn_point)
		crossbowman.position = world_position
		crossbowman.unit_owner_id = current_player.player_id
		crossbowman.unit_coords = spawn_point
		crossbowman.set_color(current_player.flag_color)
		crossbowman.fog_disperser_point_light.visible = true
		crossbowman.fog_dispenser_scene.set_fog_disperser_enabled(true)
	crossbowman.check_if_unit_is_in_water()
	
func spawn_halberdman(restore: bool = false):
	var halberdman = preload("res://scenes/Units/Halberdman.tscn").instantiate()
	add_child(halberdman)
	if(!restore):
		var current_player: Player = get_tree().get_first_node_in_group("players").current_player
		var spawn_point = pos_clicked
		var world_position = map_to_local(spawn_point)
		halberdman.position = world_position
		halberdman.unit_owner_id = current_player.player_id
		halberdman.unit_coords = spawn_point
		halberdman.set_color(current_player.flag_color)
		halberdman.fog_disperser_point_light.visible = true
		halberdman.fog_dispenser_scene.set_fog_disperser_enabled(true)
	halberdman.check_if_unit_is_in_water()
	
func spawn_mage(restore: bool = false):
	var mage = preload("res://scenes/Units/Mage.tscn").instantiate()
	add_child(mage)
	if(!restore):
		var current_player: Player = get_tree().get_first_node_in_group("players").current_player
		var spawn_point = pos_clicked
		var world_position = map_to_local(spawn_point)
		mage.position = world_position
		mage.unit_owner_id = current_player.player_id
		mage.unit_coords = spawn_point
		mage.set_color(current_player.flag_color)
		mage.fog_disperser_point_light.visible = true
		mage.fog_dispenser_scene.set_fog_disperser_enabled(true)
	mage.check_if_unit_is_in_water()

	
func spawn_scout(restore: bool = false):
	var scout = preload("res://scenes/Units/Scout.tscn").instantiate()
	add_child(scout)
	if(!restore):
		var current_player: Player = get_tree().get_first_node_in_group("players").current_player
		var spawn_point = pos_clicked
		var world_position = map_to_local(spawn_point)
		scout.position = world_position
		scout.unit_owner_id = current_player.player_id
		scout.unit_coords = spawn_point
		scout.set_color(current_player.flag_color)
		scout.fog_disperser_point_light.visible = true
		scout.fog_dispenser_scene.set_fog_disperser_enabled(true)
	scout.check_if_unit_is_in_water()

	
func spawn_shieldman(restore: bool = false):
	var shieldman = preload("res://scenes/Units/Shieldman.tscn").instantiate()
	add_child(shieldman)
	if(!restore):
		var current_player: Player = get_tree().get_first_node_in_group("players").current_player
		var spawn_point = pos_clicked
		var world_position = map_to_local(spawn_point)
		shieldman.position = world_position
		shieldman.unit_owner_id = current_player.player_id
		shieldman.unit_coords = spawn_point
		shieldman.set_color(current_player.flag_color)
		shieldman.fog_disperser_point_light.visible = true
		shieldman.fog_dispenser_scene.set_fog_disperser_enabled(true)
	shieldman.check_if_unit_is_in_water()

	
func spawn_warrior(restore: bool = false):
	var warrior = preload("res://scenes/Units/Warrior.tscn").instantiate()
	add_child(warrior)
	if(!restore):
		var current_player: Player = get_tree().get_first_node_in_group("players").current_player
		var spawn_point = pos_clicked
		var world_position = map_to_local(spawn_point)
		warrior.position = world_position
		warrior.unit_owner_id = current_player.player_id
		warrior.unit_coords = spawn_point
		warrior.set_color(current_player.flag_color)
		warrior.fog_disperser_point_light.visible = true
		warrior.fog_dispenser_scene.set_fog_disperser_enabled(true)
	warrior.check_if_unit_is_in_water()


func reload_unit(saved_unit: BaseUnit) -> void:
	#clear highlight to avoid showing range of possibly nonexistent unit
	clear_highlight()
	var unit_reloaded: bool = false
	match saved_unit.unit_name:
		"Archer":
			spawn_archer(true)
			unit_reloaded = true
		"Arch Mage":
			spawn_archmage(true)
			unit_reloaded = true
		"Cavalry":
			spawn_cavalry(true)
			unit_reloaded = true
		"Crossbowman":
			spawn_crossbowman(true)
			unit_reloaded = true
		"Halberdman":
			spawn_halberdman(true)
			unit_reloaded = true
		"Mage":
			spawn_mage(true)
			unit_reloaded = true
		"Scout":
			spawn_scout(true)
			unit_reloaded = true
		"Shieldman":
			spawn_shieldman(true)
			unit_reloaded = true
		"Spearman":
			spawn_spearman(true)
			unit_reloaded = true
		"Warrior":
			spawn_warrior(true)
			unit_reloaded = true
	if unit_reloaded:
		var player_manager: PlayersManager = get_tree().get_first_node_in_group("players")
		units[units.size() -1].health = saved_unit.health
		units[units.size() -1].attack = saved_unit.attack
		units[units.size() -1].defense = saved_unit.defense
		units[units.size() -1].movementRange = saved_unit.movementRange
		units[units.size() -1].rangeOfView = saved_unit.rangeOfView
		units[units.size() -1].unit_owner_id = saved_unit.unit_owner_id
		units[units.size() -1].unit_coords = saved_unit.unit_coords
		# This is to ensure the unit is not stuck between tiles and can be selected
		var unit_pos=saved_unit.position
		unit_pos=local_to_map(unit_pos)
		unit_pos=map_to_local(unit_pos)
		units[units.size() -1].position = unit_pos
		units[units.size() -1].set_color(player_manager.players[saved_unit.unit_owner_id].flag_color)
		units[units.size() -1].check_if_unit_is_in_water()

func clear_unit_info()->void:
	if unit_info!=null and is_instance_valid(unit_info):
		unit_info.queue_free()


func get_neighbors(position: Vector2):
	var neighbors = []
	var offsets = [
		Vector2(1, 0), Vector2(-1, 0), 
		Vector2(0, 1), Vector2(0, -1),
		Vector2(1, -1), Vector2(-1, 1)
	]
	
	for offset in offsets:
		var neighbor_pos = position + offset
		neighbors.append(neighbor_pos)
		
func highlight_enemy_targets(unit: BaseUnit, start_position: Vector2):
	if unit == null:
		return
	var offsets = [
		Vector2(1, 0), Vector2(-1, 0), 
		Vector2(0, 1), Vector2(0, -1),
		Vector2(1, 1), Vector2(-1, 1),
		Vector2(-1,-1), Vector2(1,-1)
	]
	for tileX in offsets:
		var target_position = start_position + tileX
		var tile = map_layer.terrain_dict.find_key(map_layer.get_cell_atlas_coords(target_position))
		var empty = map_layer.terrain_dict.find_key(map_layer.get_cell_atlas_coords(Vector2(-4,-4)))
		var tmp = map_layer.terrain_dict.find_key(map_layer.get_cell_atlas_coords(target_position))
		var enemy_unit = get_unit_at_position(target_position)
		if is_cell_not_city(target_position) and tile != empty:
			if enemy_unit != null:
				print(enemy_unit.name)
				if enemy_unit.unit_owner_id != selected_unit.unit_owner_id:
					highlight_layer.set_cell(target_position, 0, Vector2i(3,0), 2)
				
	
func unit_attack(unit, pos):
	var enemy = get_unit_at_position(pos)
	if enemy:
		if enemy.unit_owner_id != unit.unit_owner_id:
			if enemy.position.x < unit.position.x:
				unit.sprite.flip_h = true
			else:
				unit.sprite.flip_h = false
			unit.sprite.play("Attack")
			#await get_tree().create_timer(2).timeout
			await unit.sprite.animation_finished
			unit.sprite.play("Idle")
			enemy.takeDamage(unit.attack)
	
	#var enemy_position = []
	#var neighbors = get_neighbors(selected_unit.position)
	
	#for pos in neighbors:
	#	var unit = get_unit_at_position(pos)
	#	if unit and unit.unit_owner_id != selected_unit.unit_owner_id:
	#		enemy_position.append(pos)
	#		highlight_layer.set_cell(pos, 0, Vector2i(0,0), 2)

#func get_unit_at(position: Vector2) -> BaseUnit:
#	var world_position = map_to_local(position)
#	for unit in get_children():
#		if unit.position.distance_to(world_position)

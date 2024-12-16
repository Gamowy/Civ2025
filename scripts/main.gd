extends Node2D
class_name Main


var save_path = "user://save.dat"
# Everything below needs to be saved in save_game() func
# ---------------------------------------------------------------------
# Contains data about players
@onready var players_manager = $PlayersManager

# Contains data for map layers
@onready var map_layer:MapLayer=$Map/MapLayer
@onready var resource_layer:ResourceLayer = $"Map/ResourceLayer"
@onready var city_layer = $"Map/CityLayer"
# ---------------------------------------------------------------------

@onready var user_interface = $UILayer/UserInterface
@onready var fog_thick_layer:FogThickLayer = $"Map/FogThickLayer"
@onready var camera=$Camera
var previous_cell:Vector2=Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	map_layer.generate_map()
	resource_layer.generate_resources(map_layer)
	fog_thick_layer.generate_fog(map_layer)
	#Set camera movement boundary
	camera.set_camera_boundary(Vector2(map_layer.width,map_layer.height))
	initGame()

func initGame() -> void:
	# TEST
	players_manager.add_player(0, "Andrzej", Color.GREEN)
	players_manager.add_player(1, "Adam", Color.RED)
	players_manager.add_player(2, "Karol", Color.BLUE)
	city_layer.add_city(Vector2i(10, 10), players_manager.players[0])
	city_layer.add_city(Vector2i(30, 15), players_manager.players[0])
	city_layer.add_city(Vector2i(50, 20), players_manager.players[1])
	city_layer.add_city(Vector2i(10, 25), players_manager.players[1])
	city_layer.add_city(Vector2i(30, 25), players_manager.players[2])
	setup_current_player()

# Mouse input on map
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		var global_clicked=get_global_mouse_position()
		if event.is_pressed():
			var pos_clicked=map_layer.local_to_map(to_local(global_clicked))
			map_layer.set_cell(previous_cell,map_layer.get_cell_source_id(previous_cell),map_layer.get_cell_atlas_coords(previous_cell),0)
			map_layer.set_cell(pos_clicked,map_layer.get_cell_source_id(pos_clicked),map_layer.get_cell_atlas_coords(pos_clicked),1)			
			previous_cell=pos_clicked
			
			print("clicked tile: "+str(pos_clicked)+" "+map_layer.terrain_dict.find_key(map_layer.get_cell_atlas_coords(pos_clicked))+
			", resource: "+resource_layer.resource_dict.find_key(resource_layer.get_cell_atlas_coords(pos_clicked))+
			", fog: "+fog_thick_layer.fog_dict.find_key(fog_thick_layer.get_cell_atlas_coords(pos_clicked)))			

func setup_current_player() -> void:
	var player: Player = players_manager.current_player
	fog_thick_layer.generate_fog()
	fog_thick_layer.restore_uncovered_cells(player.uncovered_cells)
	city_layer.switch_city_fog(player)
	user_interface.update_turn_label(player.player_name, player.flag_color)
	user_interface.update_resources("gold", str(player.gold))
	user_interface.update_resources("wood", str(player.wood))
	user_interface.update_resources("stone", str(player.stone))
	user_interface.update_resources("steel", str(player.steel))
	user_interface.update_resources("food", str(player.food))
	# TEST
	var fog_disperser_label = $FogDisperserDemo/Label
	fog_disperser_label.text = player.player_name
	fog_disperser_label.modulate = player.flag_color

# All properties within class annotated with @export or @export_storage will be saved for restoring
# Use @export_storage if you want to save property without displaying it in editor
# Implement reload() method to restore class based on previously saved state
# If class contains inner classes (e.g. CityLayer), you need to save them independently 
func save_game():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	
	# Save playermanager data
	file.store_var(players_manager.number_of_players, true)
	file.store_var(players_manager.current_player_id, true)
	file.store_var(players_manager.turn_number, true)
	for player: Player in players_manager.players:
		file.store_var(player, true)
	
	# Save map layer
	file.store_var(map_layer, true)
	# Save resource layer
	file.store_var(resource_layer, true)
	
	# Save city layer
	file.store_var(city_layer.cities.size(), true)
	for city in city_layer.cities:
		file.store_var(city, true)
	file.close()
	

# When loading previous state, make sure the order of loading is same as in save_game() method
func load_game():
	var file = FileAccess.open(save_path, FileAccess.READ)
	
	# Restore playermanager data
	var saved_number_of_players = file.get_var(true)
	players_manager.current_player_id = file.get_var(true)
	players_manager.turn_number = file.get_var(true)
	# Clear old players and restore players data
	players_manager.clear_players()
	for i in range(saved_number_of_players):
		var saved_player: Player = file.get_var(true)
		players_manager.reload_player(saved_player)

	# Restore map layer
	var saved_map_layer: MapLayer = file.get_var(true)
	map_layer.reload(saved_map_layer)
	
	# Restore resource layer
	var saved_resource_layer: ResourceLayer = file.get_var(true)
	resource_layer.reload(saved_resource_layer)
	
	# Restore city layer data
	var saved_number_of_cities = file.get_var(true)
	# Clear old cities and restore saved cities
	city_layer.clear_cities()
	for i in range(saved_number_of_cities):
		var saved_city = file.get_var(true)
		city_layer.reload_city(saved_city)
	file.close()
	
# UI Layer signal handlers
func _on_ui_layer_end_player_turn() -> void:
	players_manager.save_current_player_fog(fog_thick_layer.get_uncovered_cells())
	players_manager.switch_players()
	setup_current_player()
	
func _on_ui_layer_save_game() -> void:
	players_manager.save_current_player_fog(fog_thick_layer.get_uncovered_cells())
	save_game()

func _on_ui_layer_load_game() -> void:
	load_game()
	setup_current_player()

# PlayerManager signal handlers
func _on_players_manager_current_player_resource_changed(resource: String, value: int) -> void:
	user_interface.update_resources(resource, str(value))

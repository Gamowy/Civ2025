extends Node2D
class_name Main

var save_path = FilePaths.save_path
# Everything below needs to be saved in save_game() func
# ---------------------------------------------------------------------
# Contains data about players
@onready var players_manager = $PlayersManager

# Contains data for map layers
@onready var map_layer:MapLayer=$Map/MapLayer
@onready var resource_layer:ResourceLayer = $"Map/ResourceLayer"
@onready var city_layer = $"Map/CityLayer"
@onready var unit_layer = $"Map/UnitLayer"
# ---------------------------------------------------------------------
@onready var map = $Map
@onready var ui_layer = $UILayer
@onready var user_interface = $UILayer/UserInterface
@onready var action_menu = $UILayer/ActionsMenu
@onready var transition = $UILayer/Transition
@onready var fog_thick_layer:FogThickLayer = $"Map/FogThickLayer"
@onready var camera=$Camera
@onready var music_player: AudioStreamPlayer = $MusicPlayer

var soundtrack_list = [
	preload("res://audio/soundtrack/Game_1.mp3"),
	preload("res://audio/soundtrack/Game_2.mp3"),
	preload("res://audio/soundtrack/Game_3.mp3"),
	preload("res://audio/soundtrack/Game_4.mp3"),
	preload("res://audio/soundtrack/Game_5.mp3"),
	preload("res://audio/soundtrack/Game_6.mp3"),
	preload("res://audio/soundtrack/Game_7.mp3"),
	preload("res://audio/soundtrack/Game_8.mp3"),
	preload("res://audio/soundtrack/Game_9.mp3"),
	preload("res://audio/soundtrack/Game_10.mp3"),
	preload("res://audio/soundtrack/Game_11.mp3"),
	preload("res://audio/soundtrack/Game_12.mp3"),
	preload("res://audio/soundtrack/Game_13.mp3"),
	preload("res://audio/soundtrack/Game_14.mp3"),
	preload("res://audio/soundtrack/Game_15.mp3"),
	preload("res://audio/soundtrack/Game_16.mp3"),
	preload("res://audio/soundtrack/Game_17.mp3"),
	preload("res://audio/soundtrack/Game_18.mp3")
]
var previous_cell:Vector2=Vector2(0,0)
var isLoading = false

# Game parameters
var mapHeight = 48
var mapWidth = 48
var numberOfPlayers = 3
var playerNames = ["Andrzej", "Adam", "Karol"]
var playerColors = [Color.RED, Color.GREEN, Color.BLUE]
var selectedSeed : String

var LOADING_SCREEN = "res://scenes/ui/loading_screen.tscn"

var adding_city = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	transition.set_black_screen()
	map_layer.width = mapWidth
	map_layer.height = mapHeight
	map_layer.set_seed(selectedSeed)
	map_layer.generate_map()
	resource_layer.set_seed(selectedSeed)
	resource_layer.generate_resources(map_layer)
	fog_thick_layer.generate_fog(map_layer)
	
	if isLoading:
		load_game()
	else:
		initGame()
	transition.fade_to_normal()
	await transition.transition_finished
	music_player.set("spatial", false)
	play_next_track()
	

func initGame() -> void:
	var rng = RandomNumberGenerator.new()
	for x in range(0, numberOfPlayers):
		players_manager.add_player(x, playerNames[x], playerColors[x])
		city_layer.add_city(Vector2i(rng.randi_range(0, mapWidth-1), rng.randi_range(0, mapHeight-1)), players_manager.players[x])
	setup_current_player()
	camera.set_camera_boundary(Vector2(map_layer.width,map_layer.height))
	
# Mouse input on map
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		var global_clicked=get_global_mouse_position()
		if event.is_pressed():
			var pos_clicked: Vector2i =map_layer.local_to_map(to_local(global_clicked))
			map_layer.set_cell(previous_cell,map_layer.get_cell_source_id(previous_cell),map_layer.get_cell_atlas_coords(previous_cell),0)
			map_layer.set_cell(pos_clicked,map_layer.get_cell_source_id(pos_clicked),map_layer.get_cell_atlas_coords(pos_clicked),1)			
			previous_cell=pos_clicked
			
			var tile = map_layer.terrain_dict.find_key(map_layer.get_cell_atlas_coords(pos_clicked))
			var resource = resource_layer.resource_dict.find_key(resource_layer.get_cell_atlas_coords(pos_clicked))
			var fog = fog_thick_layer.fog_dict.find_key(fog_thick_layer.get_cell_atlas_coords(pos_clicked))
			print("clicked tile: " + str(pos_clicked) + " " + tile + ", resource: " + resource + ", fog: "+ fog)
			
			if adding_city and event.is_double_tap():
				var cities_coords = get_coords_around_cities()
				if (pos_clicked.x >= 0 and pos_clicked.x <= map_layer.width 
				and pos_clicked.y >= 0 and pos_clicked.y <= map_layer.height 
				and tile != "ocean" and resource == "empty" and fog == "empty"
				and !cities_coords.has(pos_clicked)):
						build_city(pos_clicked)
				else:
					# Display info about incorrect city placment and wait for some time before reverting to old message
					user_interface.update_action_info("Selected tile is occupied or not allowed!", Color.RED, 3)

func get_coords_around_cities() -> Array[Vector2i]:
	var cities: Array[City] = city_layer.cities
	var coords_array: Array[Vector2i]
	for city in cities:
		for x in range(-5, 5):
			for y in range(-5, 5):
				coords_array.append(Vector2i(city.city_coords.x + x, city.city_coords.y + y))
	return coords_array

func build_city(pos: Vector2i) -> void:
	var prompt_window: CityBuildPrompt = load("res://scenes/ui/city_build_prompt.tscn").instantiate()
	user_interface.hide_action_info()
	ui_layer.add_child(prompt_window)
	var result = await prompt_window.button_pressed
	if result == CityBuildPrompt.Result.Yes:
		city_layer.add_city(pos, players_manager.current_player, prompt_window.city_name.text)
	else:
		action_menu.revert_last_action_cost()
		
	adding_city = false
	map.process_mode = Node.PROCESS_MODE_INHERIT
	ui_layer.remove_child(prompt_window)
	prompt_window.queue_free()
	user_interface.switch_ui_visibility()
	
func setup_current_player() -> void:
	var player: Player = players_manager.current_player
	fog_thick_layer.restore_uncovered_cells(player.uncovered_cells)
	city_layer.switch_city_fog(player)
	unit_layer.switch_unit_fog(player)
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
		
	# Save unit layer
	file.store_var(unit_layer.units.size(), true)
	for unit in unit_layer.units:
		file.store_var(unit, true)	
	file.close()
	
# When loading previous state, make sure the order of loading is same as in save_game() method
func load_game():
	if FileAccess.file_exists(save_path):
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
			
		# Restore unit layer data
		var saved_number_of_units = file.get_var(true)
		unit_layer.clear_units()
		for i in range(saved_number_of_units):
			var saved_unit = file.get_var(true)
			unit_layer.reload_unit(saved_unit)
		
		file.close()
		setup_current_player()
		camera.set_camera_boundary(Vector2(map_layer.width,map_layer.height))
	else:
		printerr("Save file not found!")
	
func switch_turns() -> void:
	transition.fade_to_black()
	await transition.transition_finished
	players_manager.save_current_player_fog(fog_thick_layer.get_uncovered_cells())
	city_layer.get_resources_from_cities(players_manager.current_player)
	players_manager.switch_players()
	setup_current_player()
	transition.fade_to_normal()
	await transition.transition_finished
			
func play_next_track():
	if soundtrack_list.size() > 0:
		var random_track = soundtrack_list[randi() % soundtrack_list.size()]
		
		music_player.stream = random_track
		music_player.play()
		
		if music_player.is_connected("finished", Callable(self, "_on_music_finished")):
			music_player.disconnect("finished", Callable(self, "_on_music_finished"))
		music_player.connect("finished", Callable(self, "_on_music_finished"))

func _on_music_finished():
	play_next_track()

func exit_to_menu() -> void:
	get_tree().change_scene_to_file(LOADING_SCREEN);
	get_tree().root.remove_child(self)
	self.queue_free()
	
# UI Layer signal handlers
func _on_ui_layer_end_player_turn() -> void:
	switch_turns()
	
func _on_ui_layer_save_game() -> void:
	players_manager.save_current_player_fog(fog_thick_layer.get_uncovered_cells())
	save_game()

func _on_ui_layer_load_game() -> void:
	transition.fade_to_black()
	await transition.transition_finished
	load_game()
	setup_current_player()
	transition.fade_to_normal()
	await transition.transition_finished

func _on_ui_layer_build_city() -> void:
	user_interface.switch_ui_visibility()
	user_interface.show_action_info("Double tap on empty tile to build new city")
	map.process_mode = Node.PROCESS_MODE_DISABLED
	adding_city = true

# PlayerManager signal handlers
func _on_players_manager_current_player_resource_changed(resource: String, value: int) -> void:
	user_interface.update_resources(resource, str(value))

func _on_ui_layer_exit_to_menu() -> void:
	exit_to_menu()

extends Node2D
class_name Main

##Emitted when the turn ends
signal turn_ended

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

## Volume at which the music should be played
@export var music_volume_db:float=-15
var soundtrack_list = [
	preload("res://audio/soundtrack/1. Eldertide Loop.ogg"),
	preload("res://audio/soundtrack/2. Moonshadow Loop.ogg"),
	preload("res://audio/soundtrack/4. Starforge (No Vocals) Loop.ogg"),
	preload("res://audio/soundtrack/5. Wraithsong Loop.ogg"),
	preload("res://audio/soundtrack/6. Dreamspire Loop.ogg")
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
	music_player.volume_db=-80
	music_player.set("spatial", false)
	play_next_track()
	#Fade in music
	var tween = get_tree().create_tween()
	tween.tween_property(music_player,"volume_db", music_volume_db, 3.0)
	

func initGame() -> void:
	for x in range(0, numberOfPlayers):
		players_manager.add_player(x, playerNames[x], playerColors[x])
		city_layer.create_initial_city(map_layer,resource_layer,players_manager.players[x])
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
				var cities_coords = city_layer.get_coords_around_cities()
				if (pos_clicked.x >= 0 and pos_clicked.x <= map_layer.width 
				and pos_clicked.y >= 0 and pos_clicked.y <= map_layer.height 
				and tile != "ocean" and resource == "empty" and fog == "empty"
				and !cities_coords.has(pos_clicked)):
						build_city(pos_clicked)
				else:
					# Display info about incorrect city placment and wait for some time before reverting to old message
					user_interface.update_action_info("Selected tile is occupied or not allowed!", Color.RED, 3)

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
	if !isLoading:
		players_manager.restore_player_energy(player)
	user_interface.update_energy(player.energy, player.max_energy)

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
		isLoading = false
	else:
		isLoading = false
		printerr("Save file not found!")
	
func switch_turns() -> void:
	turn_ended.emit()
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

func camera_transition():
	for city in city_layer.cities:
		if city.city_owner==players_manager.players[players_manager.current_player_id]:
			var new_camera_pos:Vector2=city.global_position
			camera.set_camera_position(new_camera_pos)
			return

func exit_to_menu() -> void:
	get_tree().change_scene_to_file(LOADING_SCREEN);
	get_tree().root.remove_child(self)
	self.queue_free()

## Checks if somebody won the game, should be connected to "city_destroyed" signal from city_layer
func check_win_condition()->void:
	if len(city_layer.cities)>0:
		var potential_winner=city_layer.cities[0].city_owner
		for city in city_layer.cities:
			if city.city_owner!=potential_winner:
				return
		get_tree().paused=true
		var game_over_screen:GameOverScreen=GameOverScreen.get_game_over_screen(potential_winner)
		game_over_screen.menu_button_pressed.connect(exit_to_menu)
		ui_layer.add_child(game_over_screen)

# UI Layer signal handlers
func _on_ui_layer_end_player_turn() -> void:
	switch_turns()
	
func _on_ui_layer_save_game() -> void:
	players_manager.save_current_player_fog(fog_thick_layer.get_uncovered_cells())
	save_game()

func _on_ui_layer_load_game() -> void:
	transition.fade_to_black()
	await transition.transition_finished
	isLoading = true
	load_game()
	transition.fade_to_normal()
	await transition.transition_finished

func _on_ui_layer_build_city() -> void:
	user_interface.switch_ui_visibility()
	user_interface.show_action_info("Double tap on empty tile to build new city")
	map.process_mode = Node.PROCESS_MODE_DISABLED
	adding_city = true
	
func _on_ui_layer_repair_cities() -> void:
	var current_player: Player = players_manager.current_player
	for city in city_layer.cities:
		if city.city_owner == current_player:
			city.city_health += 10
	
func _on_ui_layer_heal_units() -> void:
	var current_player_id = players_manager.current_player_id
	for unit in unit_layer.units:
		if unit.unit_owner_id == current_player_id:
			unit.health += 10
			
func _on_ui_layer_feed_units() -> void:
	players_manager.restore_player_energy(players_manager.current_player)

func _on_ui_layer_units_training() -> void:
	players_manager.increase_player_max_energy(players_manager.current_player)

func _on_ui_layer_trade_gold() -> void:
	var current_player : Player = players_manager.current_player
	current_player.gold -= 20
	current_player.wood += 5
	current_player.steel += 5
	current_player.stone += 5
	current_player.food += 5

func _on_ui_layer_spy_on_enemies() -> void:
	var current_fog = fog_thick_layer.get_uncovered_cells()
	var coords = city_layer.get_coords_around_cities()
	for coord in coords:
		if not current_fog.has(coord):
			current_fog.append(coord)
	fog_thick_layer.restore_uncovered_cells(current_fog)
		
func _on_user_interface_open_settings() -> void:
	unit_layer.clear_unit_info()
	
func _on_user_interface_open_actions_menu() -> void:
	unit_layer.clear_unit_info()

# PlayerManager signal handlers
func _on_players_manager_current_player_resource_changed(resource: String, value: int) -> void:
	user_interface.update_resources(resource, str(value))

func _on_players_manager_current_player_energy_changed(energy: int, max_energy: int) -> void:
	user_interface.update_energy(energy, max_energy)

func _on_ui_layer_exit_to_menu() -> void:
	exit_to_menu()

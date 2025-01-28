extends Control
class_name MainMenu

@onready var prompt: Control = $PromptWindow
@onready var v_box_container: VBoxContainer = $VBoxContainer
@onready var texture_rect: TextureRect = $TextureRect
@onready var new_game_settings: VBoxContainer = $NewGameSettings
@onready var logo: TextureRect = $TextureRect/logo
@onready var players_setup: VBoxContainer = $PlayersSetup

@onready var player: SpinBox = $NewGameSettings/Player
@onready var map_size: OptionButton = $NewGameSettings/HBoxContainer2/MapSize
@onready var map_seed: LineEdit = $NewGameSettings/MapSeed

@onready var player_3: VBoxContainer = $PlayersSetup/VBoxContainer/Hbox3
@onready var player_4: VBoxContainer = $PlayersSetup/VBoxContainer/Hbox4

@onready var player_1_name: LineEdit = $PlayersSetup/VBoxContainer/Hbox1/Player1/Player1Name
@onready var player_2_name: LineEdit = $PlayersSetup/VBoxContainer/Hbox2/Player2/Player2Name
@onready var player_3_name: LineEdit = $PlayersSetup/VBoxContainer/Hbox3/Player3/Player3Name
@onready var player_4_name: LineEdit = $PlayersSetup/VBoxContainer/Hbox4/Player4/Player4Name

@onready var player_1_color_picker: ColorRect = $PlayersSetup/VBoxContainer/Hbox1/Player1/Player1ColorPicker
@onready var player_2_color_picker: ColorRect = $PlayersSetup/VBoxContainer/Hbox2/Player2/Player2ColorPicker
@onready var player_3_color_picker: ColorRect = $PlayersSetup/VBoxContainer/Hbox3/Player3/Player3ColorPicker
@onready var player_4_color_picker: ColorRect = $PlayersSetup/VBoxContainer/Hbox4/Player4/Player4ColorPicker


@onready var start: SoundButton = $PlayersSetup/Buttons/Start
@onready var music_player = $MusicPlayer

var main_menu_music = preload("res://audio/main_menu/Main_Menu.mp3")

var MAIN = load("res://scenes/main.tscn")
var save_path = FilePaths.save_path

enum Prompt_Type {NEW_GAME, LOAD_GAME}
var prompt_type = null
var load_scene = "res://scenes/ui/loading_screen.tscn"
var player_names = []
var colors = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ResourceLoader.load_threaded_request(load_scene)
	texture_rect.visible = true
	v_box_container.visible = true
	prompt.visible = false
	player.get_line_edit().virtual_keyboard_type = LineEdit.KEYBOARD_TYPE_NUMBER
	music_player.set("spatial", false)
	music_player.stream = main_menu_music
	music_player.play()

func _on_new_game_pressed() -> void:
	v_box_container.visible = false
	logo.visible = false
	new_game_settings.visible = true

func _on_back_pressed() -> void:
	if (players_setup.visible):
		players_setup.visible = false
		new_game_settings.visible = true
		player_3.visible = false
		player_4.visible = false
		player_1_name.text=""
		player_2_name.text=""
		player_3_name.text=""
		player_4_name.text=""
		player_1_color_picker.color = Color.WHITE
		player_2_color_picker.color = Color.WHITE
		player_3_color_picker.color = Color.WHITE
		player_4_color_picker.color = Color.WHITE
	elif(new_game_settings.visible):
		new_game_settings.visible = false
		v_box_container.visible = true
		logo.visible = true
		player.value = 2
		map_size.selected = 0
		map_seed.text = ""
		
func check_validation_of_players():	
	var unique_player_names = []
	var unique_colors = []

	if player.value <= 2:
		player_names = [str(player_1_name.text), str(player_2_name.text)]
		colors = [player_1_color_picker.color, player_2_color_picker.color]
	elif player.value == 3:
		player_names = [str(player_1_name.text), str(player_2_name.text), str(player_3_name.text)]
		colors = [player_1_color_picker.color, player_2_color_picker.color, player_3_color_picker.color]
	elif player.value >= 4:
		player_names = [str(player_1_name.text), str(player_2_name.text), str(player_3_name.text), str(player_4_name.text)]
		colors = [player_1_color_picker.color, player_2_color_picker.color, player_3_color_picker.color, player_4_color_picker.color]
	
	for player_name in player_names:
		if (player_name.length() < 4):
			start.disabled = true
			break				
		if not unique_player_names.has(player_name):
			unique_player_names.append(player_name)
			
	for player_color in colors:
		if not unique_colors.has(player_color):
			unique_colors.append(player_color)
			
	if unique_colors.size() != colors.size() or unique_player_names.size() != player_names.size():
		start.disabled = true
	else:
		start.disabled = false

func _on_start_pressed() -> void:
	prompt.setPrompt("Do you want to start a new game?")
	prompt_type = Prompt_Type.NEW_GAME
	v_box_container.visible = false
	texture_rect.visible = false
	new_game_settings.visible = false
	players_setup.visible = false
	prompt.visible = true	

func _on_next_pressed() -> void:
	check_validation_of_players()
	new_game_settings.visible = false
	if (player.value < 2):
		player.value = 2
	if (player.value > 4):
		player.value = 4
		
	if player.value == 3:
		player_3.visible = true
	if player.value == 4:
		player_3.visible = true
		player_4.visible = true
		
	players_setup.visible = true
	
func _on_load_game_pressed() -> void:
	if FileAccess.file_exists(save_path):
		prompt.setPrompt("Do you want to load previous save?")
	else:
		prompt.setPrompt("Game save not found.", true)
	prompt_type = Prompt_Type.LOAD_GAME
	v_box_container.visible = false
	texture_rect.visible = false
	prompt.visible = true
		
func _on_text_changed(_new_text: String) -> void:
	check_validation_of_players()
	
func _on_color_picker_color_changed() -> void:
	check_validation_of_players()

func _on_map_size_item_selected(index: int) -> void:
	if index == 0:
		player.value = 2
	elif index == 1:
		player.value = 3
	elif index == 2:
		player.value = 4

func _on_exit_pressed() -> void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit(0)

func _on_prompt_window_no() -> void:
	texture_rect.visible = true
	v_box_container.visible = true
	prompt.visible = false
	logo.visible = true
	player_3.visible = false
	player_4.visible = false
	player_1_name.text=""
	player_2_name.text=""
	player_3_name.text=""
	player_4_name.text=""
	player_1_color_picker.color = Color.WHITE
	player_2_color_picker.color = Color.WHITE
	player_3_color_picker.color = Color.WHITE
	player_4_color_picker.color = Color.WHITE
	player.value = 2
	map_size.selected = 0
	map_seed.text = ""

func _on_prompt_window_yes() -> void:
	prompt.visible = false
	match prompt_type:
		Prompt_Type.LOAD_GAME:
			var main_scene = MAIN.instantiate()
			main_scene.isLoading = true
			get_tree().root.add_child(main_scene)
			get_tree().root.remove_child(self)
		Prompt_Type.NEW_GAME:
			var main_scene = MAIN.instantiate()
			main_scene.isLoading = false
			
			if map_size.get_selected_id() == 0:
				main_scene.mapHeight = 48
				main_scene.mapWidth = 48
			elif map_size.get_selected_id() == 1:
				main_scene.mapHeight = 64
				main_scene.mapWidth = 64
			elif map_size.get_selected_id() == 2:
				main_scene.mapHeight = 84
				main_scene.mapWidth = 84
				
			var new_seed = map_seed.text
			if (new_seed == ""):
				new_seed = str(RandomNumberGenerator.new().randi())
			
			main_scene.selectedSeed = new_seed
			main_scene.numberOfPlayers = int(player.value)
			main_scene.playerNames = player_names
			main_scene.playerColors = colors
			get_tree().root.add_child(main_scene)
			get_tree().root.remove_child(self)

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
@onready var map_seed: SpinBox = $NewGameSettings/MapSeed

@onready var player_3: HBoxContainer = $PlayersSetup/VBoxContainer/Player3
@onready var player_4: HBoxContainer = $PlayersSetup/VBoxContainer/Player4


@onready var player_1_name: LineEdit = $PlayersSetup/VBoxContainer/Player1/Player1Name
@onready var player_2_name: LineEdit = $PlayersSetup/VBoxContainer/Player2/Player2Name
@onready var player_3_name: LineEdit = $PlayersSetup/VBoxContainer/Player3/Player3Name
@onready var player_4_name: LineEdit = $PlayersSetup/VBoxContainer/Player4/Player4Name

@onready var player_1_color_picker: ColorRect = $PlayersSetup/VBoxContainer/Player1/Player1ColorPicker
@onready var player_2_color_picker: ColorRect = $PlayersSetup/VBoxContainer/Player2/Player2ColorPicker
@onready var player_3_color_picker: ColorRect = $PlayersSetup/VBoxContainer/Player3/Player3ColorPicker
@onready var player_4_color_picker: ColorRect = $PlayersSetup/VBoxContainer/Player4/Player4ColorPicker


@onready var start: SoundButton = $PlayersSetup/Buttons/Start

var MAIN = load("res://scenes/main.tscn")

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

func _on_new_game_pressed() -> void:
	v_box_container.visible = false
	logo.visible = false
	new_game_settings.visible = true

func _on_back_pressed() -> void:
	v_box_container.visible = true
	logo.visible = true
	new_game_settings.visible = false
	players_setup.visible = false
	player_3.visible = false
	player_4.visible = false
	
	player.value = 2
	map_size.selected = 0
	map_seed.value = 0
	player_1_name.text=""
	player_2_name.text=""
	player_3_name.text=""
	player_4_name.text=""
	
func check_validation_of_player(namesArray: Array, colorsArray: Array) -> bool:	
	var unique_player_names = []
	var unique_colors = []
	
	for player_name in namesArray:
		if not unique_player_names.has(player_name):
			unique_player_names.append(player_name)
			
	for player_color in colorsArray:
		if not unique_colors.has(player_color):
			unique_colors.append(player_color)
			
	if unique_colors.size() != colorsArray.size() or unique_player_names.size() != namesArray.size():
		return false
	else:
		return true

func _on_start_pressed() -> void:
	prompt.setPrompt("Do you want to start a new game?")
	prompt_type = Prompt_Type.NEW_GAME
	
	if player.value == 2:
		player_names = [str(player_1_name.text), str(player_2_name.text)]
		colors = [player_1_color_picker.color, player_2_color_picker.color]
	elif player.value == 3:
		player_names = [str(player_1_name.text), str(player_2_name.text), str(player_3_name.text)]
		colors = [player_1_color_picker.color, player_2_color_picker.color, player_3_color_picker.color]
	elif player.value == 4:
		player_names = [str(player_1_name.text), str(player_2_name.text), str(player_3_name.text), str(player_4_name.text)]
		colors = [player_1_color_picker.color, player_2_color_picker.color, player_3_color_picker.color, player_4_color_picker.color]
	
	if check_validation_of_player(player_names, colors):
		prompt.setPrompt("Do you want to start a new game?")
		prompt_type = Prompt_Type.NEW_GAME
		v_box_container.visible = false
		texture_rect.visible = false
		new_game_settings.visible = false
		players_setup.visible = false
		prompt.visible = true
		


func _on_next_pressed() -> void:
	start.disabled = true
	new_game_settings.visible = false
	if player.value == 3:
		player_3.visible = true
	if player.value == 4:
		player_3.visible = true
		player_4.visible = true
		
	players_setup.visible = true
	

func _on_load_game_pressed() -> void:
	prompt.setPrompt("Do you want to load previous save?")
	prompt_type = Prompt_Type.LOAD_GAME
	v_box_container.visible = false
	texture_rect.visible = false
	prompt.visible = true

func _on_text_changed(new_text: String) -> void:
	if new_text.length() < 4:
		start.disabled = true
	else:
		start.disabled = false


func _on_map_size_item_selected(index: int) -> void:
	if index == 0:
		player.value = 2
	elif index == 1:
		player.value = 3
	elif index == 2:
		player.value = 4

func _on_settings_pressed() -> void:
	pass # Replace with function body.


func _on_prompt_window_no() -> void:
	texture_rect.visible = true
	v_box_container.visible = true
	prompt.visible = false
	logo.visible = true


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
				main_scene.mapHeight = 64
				main_scene.mapWidth = 32
			elif map_size.get_selected_id() == 1:
				main_scene.mapHeight = 96
				main_scene.mapWidth = 64
			elif map_size.get_selected_id() == 2:
				main_scene.mapHeight = 96
				main_scene.mapWidth = 96
				
			main_scene.selectedSeed = map_seed.value
			main_scene.numberOfPlayers = int(player.value)
			main_scene.playerplayer_names = player_names
			main_scene.playerColors = colors
			get_tree().root.add_child(main_scene)
			get_tree().root.remove_child(self)
			

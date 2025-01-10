extends Control
class_name MainMenu

@onready var prompt: Control = $PromptWindow
@onready var v_box_container: VBoxContainer = $VBoxContainer
@onready var texture_rect: TextureRect = $TextureRect
@onready var new_game_settings: VBoxContainer = $NewGameSettings
@onready var logo: TextureRect = $TextureRect/logo
@onready var players_setup: VBoxContainer = $PlayersSetup

@onready var player: SpinBox = $NewGameSettings/Player
@onready var height: SpinBox = $NewGameSettings/Height
@onready var width: SpinBox = $NewGameSettings/Width

@onready var player_3: HBoxContainer = $PlayersSetup/Player3
@onready var player_4: HBoxContainer = $PlayersSetup/Player4

@onready var player_1_name: LineEdit = $PlayersSetup/Player1/Player1Name
@onready var player_2_name: LineEdit = $PlayersSetup/Player2/Player2Name
@onready var player_3_name: LineEdit = $PlayersSetup/Player3/Player3Name
@onready var player_4_name: LineEdit = $PlayersSetup/Player4/Player4Name

@onready var player_1_color: ColorPickerButton = $PlayersSetup/Player1/Player1Color
@onready var player_2_color: ColorPickerButton = $PlayersSetup/Player2/Player2Color
@onready var player_3_color: ColorPickerButton = $PlayersSetup/Player3/Player3Color
@onready var player_4_color: ColorPickerButton = $PlayersSetup/Player4/Player4Color

@onready var start: SoundButton = $PlayersSetup/Buttons/Start

var MAIN = load("res://scenes/main.tscn")

enum Prompt_Type {NEW_GAME, LOAD_GAME}
var prompt_type = null
var load_scene = "res://scenes/ui/loading_screen.tscn"
var names = []
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
	height.value = 64
	width.value = 64
	player_1_name.text=""
	player_2_name.text=""
	player_3_name.text=""
	player_4_name.text=""
	
func _on_start_pressed() -> void:
	prompt.setPrompt("Do you want to start a new game?")
	prompt_type = Prompt_Type.NEW_GAME
	
	if player.value == 2:
		names = [str(player_1_name.text), str(player_2_name.text)]
		colors = [player_1_color.color, player_2_color.color]
	elif player.value == 3:
		names = [str(player_1_name.text), str(player_2_name.text), str(player_3_name.text)]
		colors = [player_1_color.color, player_2_color.color, player_3_color.color]
	elif player.value == 4:
		names = [str(player_1_name.text), str(player_2_name.text), str(player_3_name.text), str(player_4_name.text)]
		colors = [player_1_color.color, player_2_color.color, player_3_color.color, player_4_color.color]
	
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


func _on_settings_pressed() -> void:
	pass # Replace with function body.


func _on_prompt_window_no() -> void:
	texture_rect.visible = true
	v_box_container.visible = true
	prompt.visible = false


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
			main_scene.mapHeight = int(height.value)
			main_scene.mapWidth = int(width.value)
			main_scene.numberOfPlayers = int(player.value)
			main_scene.playerNames = names
			main_scene.playerColors = colors
			get_tree().root.add_child(main_scene)
			get_tree().root.remove_child(self)
			


func _on_text_changed(new_text: String) -> void:
	if new_text.length() < 4:
		start.disabled = true
	else:
		start.disabled = false

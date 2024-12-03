extends Control

enum Prompt_Type {SAVE_GAME, LOAD_GAME, EXIT_TO_MAIN_MENU}
var prompt_type = null

@onready var master_volume_label = $"Center/PanelContainer/Content/VolumeContainer/MasterVolume/MasterVolumeValue"
@onready var sfx_volume_label = $Center/PanelContainer/Content/VolumeContainer/SFXVolume/FxVolumeValue
@onready var center = $Center
@onready var prompt = $Prompt


signal exit_settings
signal save_game
signal load_game
signal exit_to_menu

func _ready() -> void:
	center.visible = true
	prompt.visible = false

# Signals from settings menu
func _on_exit_button_pressed() -> void:
	prompt.visible = false
	center.visible = true
	exit_settings.emit()

func _on_save_game_button_pressed() -> void:
	prompt.setPrompt("Save game", "Do you want to save progress?")
	prompt_type = Prompt_Type.SAVE_GAME
	center.visible = false
	prompt.visible = true

func _on_load_game_button_pressed() -> void:
	prompt.setPrompt("Load game", "Do you want to load previous save?\nAll unsaved progress will be lost.")
	prompt_type = Prompt_Type.LOAD_GAME
	center.visible = false
	prompt.visible = true

func _on_main_menu_button_pressed() -> void:
	prompt.setPrompt("Exit to menu", "Do you want to exit to main menu?\nAll unsaved progress will be lost.")
	prompt_type = Prompt_Type.EXIT_TO_MAIN_MENU
	center.visible = false
	prompt.visible = true

func _on_master_volume_slider_value_changed(value: float) -> void:
	master_volume_label.text = str(value)
	
func _on_sfx_volume_slider_value_changed(value: float) -> void:
	sfx_volume_label.text = str(value)
	
# Signals from prompt
func _on_prompt_exit() -> void:
	_on_exit_button_pressed()
	
func _on_prompt_no() -> void:
	prompt.visible = false
	center.visible = true

func _on_prompt_yes() -> void:
	prompt.visible = false
	center.visible = true
	match prompt_type:
		Prompt_Type.SAVE_GAME:
			save_game.emit()
		Prompt_Type.LOAD_GAME:
			load_game.emit()
		Prompt_Type.EXIT_TO_MAIN_MENU:
			exit_to_menu.emit()

extends Control

enum Prompt_Type {SAVE_GAME, LOAD_GAME, EXIT_TO_MAIN_MENU}
var prompt_type = null

@onready var master_volume_label = $"Center/PanelContainer/Content/VolumeContainer/MasterVolume/MasterVolumeValue"
@onready var master_volume_slider:Slider=$Center/PanelContainer/Content/VolumeContainer/MasterVolume/MasterVolumeSlider
@onready var sfx_volume_label = $Center/PanelContainer/Content/VolumeContainer/SFXVolume/FxVolumeValue
@onready var sfx_volume_slider:Slider=$Center/PanelContainer/Content/VolumeContainer/SFXVolume/SFXVolumeSlider
@onready var center = $Center
@onready var prompt = $Prompt

signal exit_settings
signal save_game
signal load_game
signal exit_to_menu
signal master_volume_changed(volume:float)
signal sfx_volume_changed(volume:float)

var config_path = "user://config.cfg"
var config = ConfigFile.new()

func _ready() -> void:
	var config_file = config.load(config_path)
	if config_file == OK:
		for settings in config.get_sections():
			master_volume_slider.value = config.get_value(settings, "master_volume", 100)
			sfx_volume_slider.value = config.get_value(settings, "sfx_volume", 100)
	
	center.visible = true
	prompt.visible = false

# Signals from settings menu
func _on_exit_button_pressed() -> void:
	prompt.visible = false
	center.visible = true
	save_config()
	exit_settings.emit()

func _on_save_game_button_pressed() -> void:
	prompt.setPrompt("Do you want to save progress?")
	prompt_type = Prompt_Type.SAVE_GAME
	center.visible = false
	prompt.visible = true

func _on_load_game_button_pressed() -> void:
	prompt.setPrompt("Do you want to load previous save?\nAll unsaved progress will be lost.")
	prompt_type = Prompt_Type.LOAD_GAME
	center.visible = false
	prompt.visible = true

func _on_main_menu_button_pressed() -> void:
	prompt.setPrompt("Do you want to exit to main menu?\nAll unsaved progress will be lost.")
	prompt_type = Prompt_Type.EXIT_TO_MAIN_MENU
	center.visible = false
	prompt.visible = true

func _on_master_volume_slider_value_changed(value: float) -> void:
	master_volume_label.text = str(value)
	master_volume_changed.emit(master_volume_slider.value/100)
	config.set_value("settings", "master_volume", value)
	
func _on_sfx_volume_slider_value_changed(value: float) -> void:
	sfx_volume_label.text = str(value)
	sfx_volume_changed.emit(sfx_volume_slider.value/100)
	config.set_value("settings", "sfx_volume", value)
	
func _on_prompt_no() -> void:
	prompt.visible = false
	center.visible = true

func _on_prompt_yes() -> void:
	prompt.visible = false
	center.visible = true
	save_config()
	match prompt_type:
		Prompt_Type.SAVE_GAME:
			save_game.emit()
		Prompt_Type.LOAD_GAME:
			load_game.emit()
		Prompt_Type.EXIT_TO_MAIN_MENU:
			exit_to_menu.emit()

func set_master_volume_info(volume_db:float):
	master_volume_slider.value=100*db_to_linear(volume_db)
	master_volume_label.text=str(round(100*db_to_linear(volume_db)))

func set_sfx_volume_info(volume_db:float):
	sfx_volume_slider.value=int(100*db_to_linear(volume_db))
	sfx_volume_label.text=str(round(100*db_to_linear(volume_db)))

func save_config() -> void:
	config.save(config_path)
	

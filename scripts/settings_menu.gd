extends Control

@onready var master_volume_label = $"Center/PanelContainer/Content/VolumeContainer/MasterVolume/MasterVolumeValue"
@onready var sfx_volume_label = $Center/PanelContainer/Content/VolumeContainer/SFXVolume/FxVolumeValue


signal exit_settings
signal save_game
signal load_game
signal exit_to_menu

func _on_exit_button_pressed() -> void:
	exit_settings.emit()

func _on_save_game_button_pressed() -> void:
	save_game.emit()

func _on_load_game_button_pressed() -> void:
	load_game.emit()

func _on_main_menu_button_pressed() -> void:
	exit_to_menu.emit()

func _on_master_volume_slider_value_changed(value: float) -> void:
	master_volume_label.text = str(value)
	
func _on_sfx_volume_slider_value_changed(value: float) -> void:
	sfx_volume_label.text = str(value)

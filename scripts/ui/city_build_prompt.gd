extends Control
class_name CityBuildPrompt

enum Result {Yes, Cancel}

@onready var city_name = $Center/PanelContainer/Content/VBoxContainer/CityNameEdit

## Signals prompt window button pressed and returns result as argument
signal button_pressed(result: Result)

func _on_build_button_pressed() -> void:
	button_pressed.emit(Result.Yes)

func _on_exit_button_pressed() -> void:
	button_pressed.emit(Result.Cancel)

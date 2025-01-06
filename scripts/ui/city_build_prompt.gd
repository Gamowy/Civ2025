extends Control
class_name CityBuildPrompt

enum Result {Yes, Cancel}

@onready var city_name = $Center/PanelContainer/Content/VBoxContainer/CityNameEdit
@onready var build_button = $Center/PanelContainer/Content/BuildButton

## Signals prompt window button pressed and returns result as argument
signal button_pressed(result: Result)

func _ready() -> void:
	build_button.disabled = true

func _on_build_button_pressed() -> void:
	button_pressed.emit(Result.Yes)

func _on_exit_button_pressed() -> void:
	button_pressed.emit(Result.Cancel)

func _on_city_name_edit_text_changed(_new_text: String) -> void:
	if city_name.text == "":
		build_button.disabled = true
	else:
		build_button.disabled = false

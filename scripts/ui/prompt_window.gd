extends Control
class_name PromptWindow

enum Result {Yes, No}

@export_group("Prompt")
@export var text := "Prompt text"

@onready var prompt_content = $Center/PanelContainer/Content/PromptText
@onready var yes_button = $Center/PanelContainer/Content/Buttons/YesButton
@onready var no_button = $Center/PanelContainer/Content/Buttons/NoButton

## Signals prompt window yes button pressed
signal yes
## Signals prompt window no button pressed
signal no
## Signals prompt window button pressed and returns result as argument
signal button_pressed(result: Result)

func _ready() -> void:
	prompt_content.text = text

func setPrompt(content: String, infoPrompt=false) -> void:
	if (infoPrompt):
		yes_button.visible = false
		no_button.text = "OK"
	else:
		yes_button.visible = true
		no_button.text = "No"
	prompt_content.text = content

func _on_yes_button_pressed() -> void:
	yes.emit()
	button_pressed.emit(Result.Yes)
	
func _on_no_button_pressed() -> void:
	
	no.emit()
	button_pressed.emit(Result.No)

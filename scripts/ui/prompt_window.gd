extends Control

@export_group("Prompt")
@export var text := "Prompt text"

@onready var prompt_content = $Center/PanelContainer/Content/PromptText

signal yes
signal no

func _ready() -> void:
	prompt_content.text = text

func setPrompt(content: String) -> void:
	prompt_content.text = content

func _on_yes_button_pressed() -> void:
	yes.emit()
	
func _on_no_button_pressed() -> void:
	no.emit()

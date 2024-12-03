extends Control

@export_group("Prompt")
@export var prompt_title := "Prompt title"
@export var prompt_content := "Prompt text"

@onready var title_label = $PromptTitle/TitleLabel
@onready var content_label = $Center/PanelContainer/Content/PromptText

signal exit
signal yes
signal no

func _ready() -> void:
	title_label.text = str("   ", prompt_title, "   ")
	content_label.text = prompt_content

func setPrompt(title: String, content: String) -> void:
	title_label.text = str("   ", title, "   ")
	content_label.text = content

func _on_exit_button_pressed() -> void:
	exit.emit()
	
func _on_yes_button_pressed() -> void:
	yes.emit()
	
func _on_no_button_pressed() -> void:
	no.emit()

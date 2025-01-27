extends Control
## Screen where information about assets used in the game is displayed

@onready var credits_label:RichTextLabel=$CenterContainer/PanelContainer/VBoxContainer/RichTextLabel

#enables scrolling asset list by dragging
func _on_scroll_label(event:InputEvent)->void:
	if event is InputEventScreenDrag:
		credits_label.value-=event.relative.y

func _on_rich_text_label_meta_clicked(meta: Variant) -> void:
	OS.shell_open(str(meta))
	
	
func _on_menu_button_pressed() -> void:
	## this button should change the scene to main menu
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")

extends Control

@onready var top_left = $TopLeftCorner
@onready var top_right = $TopRightCorner
@onready var bottom_left = $BottomLeftCorner
@onready var bottom_right = $BottomRightCorner
@onready var action_info = $ActionInfo


@onready var gold = $TopRightCorner/Resources/Gold/GoldCount
@onready var wood = $TopRightCorner/Resources/Wood/WoodCount
@onready var stone = $TopRightCorner/Resources/Stone/StoneCount
@onready var steel = $TopRightCorner/Resources/Steel/SteelCount
@onready var food = $TopRightCorner/Resources/Food/FoodCount

@onready var turn_label = $CenterBottom/TurnLabel
@onready var action_info_label = $ActionInfo/ActionLabel

signal open_settings
signal open_actions_menu
signal end_turn

func _on_settings_button_pressed() -> void:
	open_settings.emit()

func _on_actions_button_pressed() -> void:
	open_actions_menu.emit()

func _on_end_turn_button_pressed() -> void:
	end_turn.emit()
	
func update_resources(element: String, value: String) -> void:
	match(element):
		"gold":
			gold.text = value
		"wood":
			wood.text = value
		"stone":
			stone.text = value
		"steel":
			steel.text = value
		"food":
			food.text = value

func update_turn_label(string: String, color: Color):
	turn_label.text = str("   ", string, " turn   ")
	turn_label.modulate = color
	
func show_action_info(action_text: String):
	action_info_label.text = str("        ", action_text, "        ")
	action_info.visible = true
	
func hide_action_info():
	action_info_label.text = ""
	action_info.visible = false
	
func switch_ui_visibility():
	top_left.visible = !top_left.visible
	top_right.visible = !top_right.visible
	bottom_left.visible = !bottom_left.visible
	bottom_right.visible = !bottom_right.visible

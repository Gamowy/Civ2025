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
@onready var energy = $EnergyLabel

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

func update_energy(value1: int, value2: int) -> void:
	energy.text = str("Energy: ", value1, "/", value2)

func update_turn_label(string: String, color: Color):
	turn_label.text = str("   ", string, " turn   ")
	turn_label.modulate = color
	
func show_action_info(action_text: String, color: Color = Color.WHITE):
	action_info_label.text = str("        ", action_text, "        ")
	action_info_label.modulate = color
	action_info.visible = true
	
func hide_action_info():
	action_info.visible = false
	
## Use this to display temporary messages
func update_action_info(action_text: String, color: Color = Color.WHITE, time: int = 1):
	var old_text = action_info_label.text
	var old_color = action_info_label.modulate
	action_info_label.text = str("        ", action_text, "        ")
	action_info_label.modulate = color
	await get_tree().create_timer(time).timeout
	action_info_label.text = old_text
	action_info_label.modulate = old_color

## Turns off ui visibility except for action info
func switch_ui_visibility():
	top_left.visible = !top_left.visible
	top_right.visible = !top_right.visible
	bottom_left.visible = !bottom_left.visible
	bottom_right.visible = !bottom_right.visible

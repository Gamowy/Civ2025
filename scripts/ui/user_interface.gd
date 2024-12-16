extends Control

@onready var gold = $TopRightCorner/Resources/Gold/GoldCount
@onready var wood = $TopRightCorner/Resources/Wood/WoodCount
@onready var stone = $TopRightCorner/Resources/Stone/StoneCount
@onready var steel = $TopRightCorner/Resources/Steel/SteelCount
@onready var food = $TopRightCorner/Resources/Food/FoodCount

@onready var turn_label = $CenterBottom/TurnLabel

signal open_settings
signal open_civilization_menu
signal end_turn

func _on_settings_button_pressed() -> void:
	open_settings.emit()

func _on_civilization_button_pressed() -> void:
	open_civilization_menu.emit()

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

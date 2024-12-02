extends Control

@onready var gold = $TopRightCorner/Resources/Gold/GoldCount
@onready var wood = $TopRightCorner/Resources/Wood/WoodCount
@onready var stone = $TopRightCorner/Resources/Stone/StoneCount
@onready var steel = $TopRightCorner/Resources/Steel/SteelCount
@onready var food = $TopRightCorner/Resources/Food/FoodCount

@onready var turn_label = $CenterBottom/TurnLabel

signal open_settings
signal open_menu
signal end_turn

func _on_settings_button_pressed() -> void:
	open_settings.emit()

func _on_menu_button_pressed() -> void:
	open_menu.emit()

func _on_end_turn_button_pressed() -> void:
	end_turn.emit()

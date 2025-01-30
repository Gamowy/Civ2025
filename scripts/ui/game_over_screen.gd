extends Control
class_name GameOverScreen
## The game over screen which contains information about the winning player 

## To display game over screen you can use:
## ui_layer.add_child(GameOverScreen.get_game_over_screen(<winner>))

## Emitted when menu button is pressed
signal menu_button_pressed()

@onready var label:RichTextLabel=$Center/CenterContainer/PanelContainer/VBoxContainer/RichTextLabel
var winner:Player

static func get_game_over_screen(winning_player:Player)->GameOverScreen:
	var game_over_screen:GameOverScreen=load("res://scenes/ui/game_over_screen.tscn").instantiate()
	game_over_screen.winner=winning_player
	return game_over_screen

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused=true
	if winner!=null:
		var info_string="[center]Congratulations, [color={color}]{name}[/color], you've won![/center]"
		info_string=info_string.format({"color":winner.flag_color.to_html(),"name":winner.player_name})
		label.text=info_string


func _on_menu_button_pressed() -> void:
	get_tree().paused=false
	menu_button_pressed.emit()

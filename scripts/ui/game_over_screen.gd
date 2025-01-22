extends Control
class_name GameOverScreen
## The game over screen which contains information about the winning player 

## To display game over screen you can use:
## ui_layer.add_child(GameOverScreen.get_game_over_screen(<winner>))

@onready var label:RichTextLabel=$Center/CenterContainer/PanelContainer/VBoxContainer/RichTextLabel
var winner:Player

static func get_game_over_screen(winning_player:Player):
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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_button_pressed() -> void:
	get_tree().paused=false
	get_tree().change_scene_to_file("res://scenes/ui/loading_screen.tscn")


func _on_menu_button_pressed() -> void:
	#get_tree().paused=false
	##clicking this button should change the scene to main menu
	pass # Replace with function body.

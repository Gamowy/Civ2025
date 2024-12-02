extends CanvasLayer

@onready var user_interface = $UserInterface
@onready var settings_menu = $SettingsMenu

func _ready() -> void:
	user_interface.visible = true
	settings_menu.visible = false

func _pause_game() -> void:
	get_tree().paused = true
	
func _resume_game() -> void:
	get_tree().paused = false
	
func _on_user_interface_open_settings() -> void:
	_pause_game()
	settings_menu.visible = true

func _on_settings_menu_exit_settings() -> void:
	_resume_game()
	settings_menu.visible = false

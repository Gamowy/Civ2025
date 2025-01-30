extends CanvasLayer

@onready var user_interface = $UserInterface
@onready var settings_menu = $SettingsMenu
@onready var actions_menu = $ActionsMenu

signal save_game
signal load_game
signal end_player_turn
signal exit_to_menu

# Actions menu signals
signal build_city
signal repair_cities
signal heal_units
signal spy_on_enemies

func _ready() -> void:
	user_interface.visible = true
	settings_menu.visible = false
	actions_menu.visible = false

func _pause_game() -> void:
	get_tree().paused = true
	
func _resume_game() -> void:
	get_tree().paused = false
	
# User interface signal handlers
func _on_user_interface_open_settings() -> void:
	_pause_game()
	# Set slider values before showing menu
	var index:int=AudioServer.get_bus_index("Master")
	var volume_db=AudioServer.get_bus_volume_db(index)
	settings_menu.set_master_volume_info(volume_db)
	index=AudioServer.get_bus_index("SFX")
	volume_db=AudioServer.get_bus_volume_db(index)
	settings_menu.set_sfx_volume_info(volume_db)
	settings_menu.visible = true

func _on_user_interface_open_actions_menu() -> void:
	_pause_game()
	actions_menu.visible = true

func _on_user_interface_end_turn() -> void:
	end_player_turn.emit()

# Settings menu signal handlers
func _on_settings_menu_exit_settings() -> void:
	_resume_game()
	settings_menu.visible = false

func _on_settings_menu_save_game() -> void:
	save_game.emit()
	_on_settings_menu_exit_settings()

func _on_settings_menu_load_game() -> void:
	load_game.emit()
	_on_settings_menu_exit_settings()
	
func _on_settings_menu_exit_to_menu() -> void:
	_resume_game()
	exit_to_menu.emit()

func _on_settings_menu_master_volume_changed(volume: float) -> void:
	var index:int=AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(index,linear_to_db(volume))

func _on_settings_menu_sfx_volume_changed(volume: float) -> void:
	var index:int=AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(index,linear_to_db(volume))

# Actions menu signal handlers
func _on_actions_menu_exit_actions_menu() -> void:
	_resume_game()
	actions_menu.visible = false

func _on_actions_menu_action_bought(action_name: String) -> void:
	match(action_name):
		"Build city":
			build_city.emit()
		"Repair cities":
			repair_cities.emit()
		"Heal units":
			heal_units.emit()
		"Spy on enemies":
			spy_on_enemies.emit()
		_:
			printerr("No action found")

func display_unit_info(unit_info:UnitInfo):
	add_child(unit_info)

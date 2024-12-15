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
	
# User interface signal handlers
func _on_user_interface_open_settings() -> void:
	_pause_game()
	#set slider values before showing menu
	var index:int=AudioServer.get_bus_index("Master")
	var volume_db=AudioServer.get_bus_volume_db(index)
	settings_menu.set_master_volume_info(volume_db)
	index=AudioServer.get_bus_index("SFX")
	volume_db=AudioServer.get_bus_volume_db(index)
	settings_menu.set_sfx_volume_info(volume_db)
	settings_menu.visible = true

func _on_user_interface_open_civilization_menu() -> void:
	print("Open civilization menu!")

func _on_user_interface_end_turn() -> void:
	print("End turn!")


# Settings menu signal handlers
func _on_settings_menu_exit_settings() -> void:
	_resume_game()
	settings_menu.visible = false

func _on_settings_menu_save_game() -> void:
	# TODO: replace this when saving/loading is done
	print("Save game!")
	_on_settings_menu_exit_settings()

func _on_settings_menu_load_game() -> void:
	# TODO: replace this when saving/loading is done
	print("Load game!")
	_on_settings_menu_exit_settings()
	
func _on_settings_menu_exit_to_menu() -> void:
	# TODO: replace this when main menu is done
	print("Exit to menu!")
	_on_settings_menu_exit_settings()

func _on_settings_menu_master_volume_changed(volume: float) -> void:
	var index:int=AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(index,linear_to_db(volume))


func _on_settings_menu_sfx_volume_changed(volume: float) -> void:
	var index:int=AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(index,linear_to_db(volume))

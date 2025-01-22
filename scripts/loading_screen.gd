extends Control

var next_scene = "res://scenes/ui/main_menu.tscn"
var progress = []
var scene_load_status = 0
var simulated_progress = 0.0
var config_path = FilePaths.config_path
var config = ConfigFile.new()

func _ready():
	var master_index:int=AudioServer.get_bus_index("Master")
	var sfx_index=AudioServer.get_bus_index("SFX")
	
	var config_file = config.load(config_path)
	if config_file == OK:
		for settings in config.get_sections():
			var master_volume = config.get_value(settings, "master_volume", 100)
			var sfx_volume = config.get_value(settings, "sfx_volume", 100)
			AudioServer.set_bus_volume_db(master_index, linear_to_db(float(master_volume)/100))
			AudioServer.set_bus_volume_db(sfx_index, linear_to_db(float(sfx_volume)/100))

	ResourceLoader.load_threaded_request(next_scene)
	$VBoxContainer2/ProgressBar.value = simulated_progress
	set_process(true)

func _process(delta):
	scene_load_status = ResourceLoader.load_threaded_get_status(next_scene, progress)
	
	# Simulate progress increment
	if simulated_progress < progress[0] * 100:
		simulated_progress += delta * 100 # Adjust this speed as needed
		
	# Clamp simulated progress to prevent overrun
	simulated_progress = min(simulated_progress, progress[0] * 100)
	
	# Update UI
	$VBoxContainer2/ProgressBar.value = simulated_progress
	
	# Check if the scene is loaded
	if scene_load_status == ResourceLoader.THREAD_LOAD_LOADED and simulated_progress >= 100:
		var packed_scene = ResourceLoader.load_threaded_get(next_scene)
		get_tree().change_scene_to_packed(packed_scene)

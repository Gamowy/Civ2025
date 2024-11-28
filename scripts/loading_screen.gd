extends Control

var next_scene = "res://scenes/map.tscn"
var progress = []
var scene_load_status = 0

func _ready():
	ResourceLoader.load_threaded_request(next_scene)
	
func _process(delta):
	scene_load_status = ResourceLoader.load_threaded_get_status(next_scene, progress)
	$TextureProgressBar.value = progress[0]*100
	$VBoxContainer2/ProgressBar.value = progress[0]*100

	if scene_load_status == ResourceLoader.THREAD_LOAD_LOADED:
		var packed_scene = ResourceLoader.load_threaded_get(next_scene)
		get_tree().change_scene_to_packed(packed_scene)


#Symulowanie wczytania, żeby spowolnić czas i popatrzeć na cały proces
#cały kod do tego na dole

"""
extends Control

var next_scene = "res://scenes/map.tscn"
var progress = []
var scene_load_status = 0
var simulated_progress = 0.0

func _ready():
	ResourceLoader.load_threaded_request(next_scene)
	$TextureProgressBar.value = simulated_progress
	$VBoxContainer2/ProgressBar.value = simulated_progress
	set_process(true)

func _process(delta):
	scene_load_status = ResourceLoader.load_threaded_get_status(next_scene, progress)
	
	# Simulate progress increment
	if simulated_progress < progress[0] * 100:
		simulated_progress += delta * 20  # Adjust this speed as needed
		
	# Clamp simulated progress to prevent overrun
	simulated_progress = min(simulated_progress, progress[0] * 100)
	
	# Update UI
	$TextureProgressBar.value = simulated_progress
	$VBoxContainer2/ProgressBar.value = simulated_progress
	
	# Check if the scene is loaded
	if scene_load_status == ResourceLoader.THREAD_LOAD_LOADED and simulated_progress >= 100:
		var packed_scene = ResourceLoader.load_threaded_get(next_scene)
		get_tree().change_scene_to_packed(packed_scene)

"""

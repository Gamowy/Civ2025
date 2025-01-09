extends Control
class_name MainMenu

@onready var prompt: Control = $PromptWindow
@onready var v_box_container: VBoxContainer = $VBoxContainer
@onready var texture_rect: TextureRect = $TextureRect

var MAIN = load("res://scenes/main.tscn")

enum Prompt_Type {NEW_GAME, LOAD_GAME}
var prompt_type = null
var load_scene = "res://scenes/ui/loading_screen.tscn"



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ResourceLoader.load_threaded_request(load_scene)
	texture_rect.visible = true
	v_box_container.visible = true
	prompt.visible = false

func _on_new_game_pressed() -> void:
	prompt.setPrompt("Do you want to play a new game?")
	prompt_type = Prompt_Type.NEW_GAME
	v_box_container.visible = false
	texture_rect.visible = false
	prompt.visible = true


func _on_load_game_pressed() -> void:
	prompt.setPrompt("Do you want to load previous save?")
	prompt_type = Prompt_Type.LOAD_GAME
	v_box_container.visible = false
	texture_rect.visible = false
	prompt.visible = true


func _on_settings_pressed() -> void:
	pass # Replace with function body.


func _on_prompt_window_no() -> void:
	texture_rect.visible = true
	v_box_container.visible = true
	prompt.visible = false


func _on_prompt_window_yes() -> void:
	prompt.visible = false
	match prompt_type:
		Prompt_Type.LOAD_GAME:
			##ResourceLoader.load_threaded_request(load_scene)
			##var packed_scene = ResourceLoader.load_threaded_get(load_scene)
			##get_tree().change_scene_to_packed(packed_scene)
			var main_scene = MAIN.instantiate()
			main_scene.isLoading = true
			get_tree().root.add_child(main_scene)
			get_tree().root.remove_child(self)
			self.queue_free()
		Prompt_Type.NEW_GAME:
			ResourceLoader.load_threaded_request(load_scene)
			var packed_scene = ResourceLoader.load_threaded_get(load_scene)
			get_tree().change_scene_to_packed(packed_scene)
			

extends AnimationPlayer

@onready var black_screen = $BlackScreen

signal transition_finished

func _ready():
	black_screen.visible = false

func fade_to_black():
	black_screen.visible = true
	play("fade_to_black")
	
func fade_to_normal():
	play("fade_to_normal")
	
func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_to_black":
		transition_finished.emit()
	if anim_name == "fade_to_normal":
		black_screen.visible = false
		transition_finished.emit()

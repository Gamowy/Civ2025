extends HSlider
class_name SoundHSlider
# HSlider that plays a given sound when an item is selected

@export_category("Drag started sound")
## Sound to be played when slider dragging is started
@export var drag_started_sound:AudioStream
## Pitch of drag_started_sound
@export var sound_pitch_drag_started:float=1.0
@export_category("Drag ended sound")
## Sound to be played when slider dragging stops
@export var drag_ended_sound:AudioStream
## Pitch of drag_ended_sound
@export var sound_pitch_drag_ended:float=1.0
#new signal is used to avoid passing index argument from item_selected
signal drag_ended_sound_signal

func _ready() -> void:
	if drag_started_sound==null:
		drag_started.connect(UISoundPlayer.play_sound)
	else:
		drag_started.connect(UISoundPlayer.play_sound.bind(drag_started_sound,sound_pitch_drag_started))
	if drag_ended_sound!=null:
		drag_ended.connect(drag_ended_sound_signal.emit.unbind(1))
		drag_ended_sound_signal.connect(UISoundPlayer.play_sound.bind(drag_ended_sound,sound_pitch_drag_ended))
		

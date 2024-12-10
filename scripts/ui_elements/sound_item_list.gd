extends ItemList
class_name SoundItemList
# Itemlist that plays a given sound when an item is selected

@export_category("Selection sound")
## Sound to be played when selecting an item
@export var selection_sound:AudioStream
## Pitch of selection_sound
@export var sound_pitch:float=1.0
#new signal is used to avoid passing index argument from item_selected
signal item_selected_sound

func _ready() -> void:
	item_selected.connect(item_selected_sound.emit.unbind(1))
	if selection_sound==null:
		item_selected_sound.connect(UISoundPlayer.play_sound)
	else:
		item_selected_sound.connect(UISoundPlayer.play_sound.bind(selection_sound,sound_pitch))
		

extends AudioStreamPlayer
#audio player for ui button press sounds etc
#audio player separate from ui prevents cutting off sounds after closing a menu
var button_press_sound:AudioStream=preload("res://audio/button_press.ogg")

func play_sound(sound:AudioStream=button_press_sound, pitch:float=1.0):
	stream=sound
	pitch_scale=pitch
	play()

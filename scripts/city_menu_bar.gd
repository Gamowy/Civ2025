extends Node2D

@onready var popup = $Window
@onready var info: MenuButton = $Window/Camera2D/Control/VBoxContainer/info

func _ready():
	popup.hide()

func _on_window_close_requested() -> void:
	popup.hide()

func windowPopup():
	popup.show()

func windowHide():
	popup.hide()

#Zmiana tytułu okna(na potrzeby nazwy miasta)
func menuName(cityName: String):
	popup.title = cityName

#Funkcja potrzebna do wyświetlenia informacji o mieście
func editTextOfButton(i: int, text: String):
	var itemChange = info.get_popup()
	itemChange.set_item_text(i, text)

#Funckja, dzięki której kiedy klikamy gdziekolwiek na mapie, to menu się chowa
func _on_window_focus_exited() -> void:
	popup.hide()

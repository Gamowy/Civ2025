extends CanvasLayer

@onready var popup = $Panel
@onready var info: MenuButton = $Panel/VBoxContainer/info
@onready var title = $Panel/VBoxContainer/MenuTitle/TitleLabel


func _input(event):
	if event is InputEventScreenTouch and event.pressed:
		# Check if the tap is outside the panel's boundaries
		if not popup.get_global_rect().has_point(event.position):
			popup.hide()

func _ready():
	popup.hide()

func windowPopup():
	popup.show()
	popup.grab_focus()

#Zmiana tytułu okna(na potrzeby nazwy miasta)
func menuName(cityName: String):
	title.text = str("   ", cityName, "   ")

#Funkcja potrzebna do wyświetlenia informacji o mieście
func editTextOfButton(i: int, text: String):
	var itemChange = info.get_popup()
	itemChange.set_item_text(i, text)

extends CanvasLayer

@onready var center = $Center
@onready var popup = $Center/Panel
@onready var info: MenuButton = $Center/Panel/VBoxContainer/info
@onready var title = $Center/MenuTitle/TitleLabel


func _input(event):
	if event is InputEventScreenTouch and event.pressed:
		# Check if the tap is outside the panel's boundaries
		if not popup.get_global_rect().has_point(event.position):
			center.hide()

func _ready():
	center.hide()

func windowPopup():
	center.show()

#Zmiana tytułu okna(na potrzeby nazwy miasta)
func menuName(cityName: String):
	title.text = str("   ", cityName, "   ")

#Funkcja potrzebna do wyświetlenia informacji o mieście
func editTextOfButton(i: int, text: String):
	var itemChange = info.get_popup()
	itemChange.set_item_text(i, text)

# TODO UWAGA kiedy bedziemy juz mieli graczy trzeba bedzie sprawdzic czy dane miasto nalezy
# do gracza obecnie wykonujacego ture przed wyswietleniem menu
func _on_build_pressed() -> void:
	var buildings_menu=load("res://scenes/buildings_menu.tscn").instantiate()
	if get_parent() is City:
		buildings_menu.city=get_parent()
	add_child(buildings_menu)

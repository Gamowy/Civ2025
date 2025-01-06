extends CanvasLayer

@onready var center = $Center
@onready var popup = $Center/Panel
@onready var info: MenuButton = $Center/Panel/VBoxContainer/info
@onready var title = $Center/MenuTitle/TitleLabel
@onready var unitlayer: UnitLayer = get_node("/root/Main/Map/UnitLayer")
@onready var upgrade: SoundButton = $Center/Panel/VBoxContainer/upgrade

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

func disableUpgrade():
	upgrade.disabled = true

#Funkcja potrzebna do wyświetlenia informacji o mieście
func editTextOfButton(i: int, text: String):
	var itemChange = info.get_popup()
	itemChange.set_item_text(i, text)

func _on_build_pressed() -> void:
	var buildings_menu=load("res://scenes/ui/buildings_menu.tscn").instantiate()
	if get_parent() is City:
		buildings_menu.city=get_parent()
	add_child(buildings_menu)

func _on_upgrade_pressed() -> void:
	var upgrade_menu=load("res://scenes/ui/upgrade_menu.tscn").instantiate()
	if get_parent() is City:
		upgrade_menu.city=get_parent()
	add_child(upgrade_menu)

func _on_recruit_pressed():
	unitlayer.pos_clicked.x += 1
	unitlayer.pos_clicked.y -= 1
	unitlayer.spawn_mage()
	

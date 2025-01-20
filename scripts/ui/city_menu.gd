extends CanvasLayer

@onready var menu = $Menu
@onready var center = $Menu/Center
@onready var popup = $Menu/Center/Panel
@onready var info: MenuButton = $Menu/Center/Panel/VBoxContainer/info
@onready var title = $Menu/Center/MenuTitle/TitleLabel
@onready var unitlayer: UnitLayer = get_node("/root/Main/Map/UnitLayer")
@onready var upgrade: SoundButton = $Menu/Center/Panel/VBoxContainer/upgrade

func _input(event):
	if event is InputEventScreenTouch and event.pressed:
		# Check if the tap is outside the panel's boundaries
		if not popup.get_global_rect().has_point(event.position):
			center.hide()
			menu.mouse_filter = 2

func _ready():
	center.hide()

func windowPopup():
	center.show()
	menu.mouse_filter = 0

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
	var recruitment_menu = load("res://scenes/ui/recruitment_menu.tscn").instantiate()
	if get_parent() is City:
		recruitment_menu.city = get_parent()
	add_child(recruitment_menu)
	var target_position = unitlayer.pos_clicked + Vector2i(1,-1)
	if unitlayer.is_cell_free(unitlayer.pos_clicked):
		unitlayer.pos_clicked = target_position
		unitlayer.spawn_archmage()
		print("Jednostka zrekrutowana!")
	else:
		print("Pole jest zajete!")

	

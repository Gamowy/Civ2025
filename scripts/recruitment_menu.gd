extends Control

@onready var recruit_list_scrollbar:VScrollBar=$Center/CenterContainer/PanelContainer/HBoxContainer/VBoxBuildings/BuildingList.get_v_scroll_bar()
@onready var recruit_item_list:ItemList=$Center/CenterContainer/PanelContainer/HBoxContainer/VBoxBuildings/BuildingList
@onready var recruit_button:Button=$Center/CenterContainer/PanelContainer/HBoxContainer/VBoxInfo/ButtonBuild
@onready var description_label:Label=$Center/CenterContainer/PanelContainer/HBoxContainer/VBoxInfo/Description
@onready var gold_cost_label:Label=$Center/CenterContainer/PanelContainer/HBoxContainer/VBoxInfo/HBoxCostInfo/VBoxContainer/HBoxGold/GoldCost
@onready var food_cost_label:Label=$Center/CenterContainer/PanelContainer/HBoxContainer/VBoxInfo/HBoxCostInfo/VBoxContainer2/HBoxContainer2/FoodCost
@onready var prompt_window=$PromptWindow
@onready var unit_manager = $UnitManager
@onready var unitlayer: UnitLayer = get_node("/root/Main/Map/UnitLayer")

var can_recruit:bool=true

#determines current building mode
var _recruit_mode:String="Recruit":
	set(value):
		if(value=="Recruit"):
			_recruit_mode=value
			recruit_button.text=_recruit_mode
		elif(value=="Destroy"):
			_recruit_mode=value
			recruit_button.text=_recruit_mode
		else:
			printerr(name+": invalid _building_mode value")

#city about which to display information
var city:City
var selected_building:BuildingBaseClass
var selected_unit:BaseUnit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if unitlayer.get_unit_at_position(unitlayer.pos_clicked + Vector2i(1,-1))!=null:
		recruit_button.disabled=true
		can_recruit=false
	unit_manager.city=city
	recruit_button.disabled=true
	get_tree().paused=true
	for unit in unit_manager.units:
	#	building_item_list.add_item(building.building_name,load(building.building_picture))
		
		recruit_item_list.add_child(unit)
		recruit_item_list.add_item(unit.unit_name)
		unit.health_bar.visible=false
		print(unit.unit_name)
#	_update_owned_buildings()
	

#enables scrolling buildings list by dragging
func _on_scroll_building_list(event:InputEvent)->void:
	if event is InputEventScreenDrag:
		recruit_list_scrollbar.value-=event.relative.y


#updates displayed info
func _display_unit_info(unit:BaseUnit)->void:
	description_label.text=unit.description
	gold_cost_label.text=str(unit.cost_gold)
	food_cost_label.text=str(unit.cost_food)

func _clear_building_info()->void:
	description_label.text=""
	gold_cost_label.text="0"
	food_cost_label.text="0"

#display info about a building and switch to build mode
func _on_building_list_item_selected(index: int) -> void:
#	owned_item_list.deselect_all()
	selected_unit=unit_manager.units[index]
	recruit_button.disabled=true
	if unit_manager.can_player_recruit_unit(selected_unit) and can_recruit:
		recruit_button.disabled=false
	_recruit_mode="Recruit"
	_display_unit_info(selected_unit)
	print(selected_unit.unit_name)
	


func _on_building_list_empty_clicked(_at_position: Vector2, _mouse_button_index: int) -> void:
	_clear_building_info()
	_recruit_mode="Recruit"
	recruit_button.disabled=true
	recruit_item_list.deselect_all()

#check building mode, show destroy prompt or build building
func _on_button_build_pressed() -> void:
	unit_manager.recruit_unit(selected_unit)
	city.update_city_info()
	get_tree().paused=false
	queue_free()
		

# cancel destroying building
func _on_prompt_window_no() -> void:
	prompt_window.visible=false

#exit building menu and unpause game
func _on_exit_button_pressed() -> void:
	city.update_city_info()
	get_tree().paused=false
	queue_free()

extends Control

@onready var owned_list_scrollbar:VScrollBar=$Center/CenterContainer/PanelContainer/HBoxContainer/VBoxOwned/OwnedList.get_v_scroll_bar()
@onready var building_list_scrollbar:VScrollBar=$Center/CenterContainer/PanelContainer/HBoxContainer/VBoxBuildings/BuildingList.get_v_scroll_bar()
@onready var owned_item_list:ItemList=$Center/CenterContainer/PanelContainer/HBoxContainer/VBoxOwned/OwnedList
@onready var building_item_list:ItemList=$Center/CenterContainer/PanelContainer/HBoxContainer/VBoxBuildings/BuildingList
@onready var build_button:Button=$Center/CenterContainer/PanelContainer/HBoxContainer/VBoxInfo/ButtonBuild
@onready var description_label:Label=$Center/CenterContainer/PanelContainer/HBoxContainer/VBoxInfo/Description
@onready var gold_cost_label:Label=$Center/CenterContainer/PanelContainer/HBoxContainer/VBoxInfo/HBoxCostInfo/VBoxContainer/HBoxGold/GoldCost
@onready var wood_cost_label:Label=$Center/CenterContainer/PanelContainer/HBoxContainer/VBoxInfo/HBoxCostInfo/VBoxContainer/HBoxWood/WoodCost
@onready var stone_cost_label:Label=$Center/CenterContainer/PanelContainer/HBoxContainer/VBoxInfo/HBoxCostInfo/VBoxContainer/HBoxStone/StoneCost
@onready var steel_cost_label:Label=$Center/CenterContainer/PanelContainer/HBoxContainer/VBoxInfo/HBoxCostInfo/VBoxContainer2/HBoxContainer/SteelCost
@onready var food_cost_label:Label=$Center/CenterContainer/PanelContainer/HBoxContainer/VBoxInfo/HBoxCostInfo/VBoxContainer2/HBoxContainer2/FoodCost
@onready var owned_label:Label=$Center/CenterContainer/PanelContainer/HBoxContainer/VBoxOwned/Label
@onready var prompt_window=$PromptWindow
@onready var building_manager=$BuildingManager
@onready var sfx_player=$AudioStreamPlayer

var build_sound:AudioStream=preload("res://sfx/build.ogg")
var destroy_sound:AudioStream=preload("res://sfx/destroy_building.ogg")

#determines current building mode
var _building_mode:String="Build":
	set(value):
		if(value=="Build"):
			_building_mode=value
			build_button.text=_building_mode
		elif(value=="Destroy"):
			_building_mode=value
			build_button.text=_building_mode
		else:
			printerr(name+": invalid _building_mode value")

#city about which to display information
var city:City
var selected_building:BuildingBaseClass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	building_manager.city=city
	build_button.disabled=true
	get_tree().paused=true
	for building in building_manager.buildings:
		building_item_list.add_item(building.building_name,load(building.building_picture))
	_update_owned_buildings()
	
#enables scrolling owned buildings list by dragging
func _on_scroll_owned_list(event:InputEvent)->void:
	if event is InputEventScreenDrag:
		owned_list_scrollbar.value-=event.relative.y
		
#enables scrolling buildings list by dragging
func _on_scroll_building_list(event:InputEvent)->void:
	if event is InputEventScreenDrag:
		building_list_scrollbar.value-=event.relative.y


func _update_owned_buildings()->void:
	owned_item_list.clear()# for some reason this method causes issues with the itemlist theme
		
	var how_many:int=0
	if city!=null:
		for building in city.buildings:
			how_many+=1
			owned_item_list.add_item(building.building_name,load(building.building_picture))
	owned_label.text="Owned ("+str(how_many)+"/5)"

#updates displayed info
func _display_building_info(building:BuildingBaseClass)->void:
	description_label.text=building.building_description
	gold_cost_label.text=str(building.gold_cost)
	wood_cost_label.text=str(building.wood_cost)
	stone_cost_label.text=str(building.stone_cost)
	steel_cost_label.text=str(building.steel_cost)
	food_cost_label.text=str(building.food_cost)

func _clear_building_info()->void:
	description_label.text=""
	gold_cost_label.text="0"
	wood_cost_label.text="0"
	stone_cost_label.text="0"
	steel_cost_label.text="0"
	food_cost_label.text="0"

#display info about a building and switch to build mode
func _on_building_list_item_selected(index: int) -> void:
	owned_item_list.deselect_all()
	selected_building=building_manager.buildings[index]
	build_button.disabled=true
	if building_manager.can_player_build_building(selected_building):
		build_button.disabled=false
	_building_mode="Build"
	_display_building_info(selected_building)

#display info about an owned building and switch to destroy mode
func _on_owned_list_item_selected(index: int) -> void:
	building_item_list.deselect_all()
	selected_building=city.buildings[index]
	build_button.disabled=false
	_building_mode="Destroy"
	_display_building_info(selected_building)


func _on_owned_list_empty_clicked(_at_position: Vector2, _mouse_button_index: int) -> void:
	_clear_building_info()
	_building_mode="Destroy"
	build_button.disabled=true
	owned_item_list.hide() #to make sure no items are selected in the list
	owned_item_list.show()


func _on_building_list_empty_clicked(_at_position: Vector2, _mouse_button_index: int) -> void:
	_clear_building_info()
	_building_mode="Build"
	build_button.disabled=true
	building_item_list.hide() #to make sure no items are selected in the list
	building_item_list.show()

#check building mode, show destroy prompt or build building
func _on_button_build_pressed() -> void:
	if _building_mode=="Destroy":
		prompt_window.visible=true
	if _building_mode=="Build":
		building_manager.build_building(selected_building)
		sfx_player.stream=build_sound
		sfx_player.play()
		_update_owned_buildings()
		if building_manager.can_player_build_building(selected_building)==false:
			build_button.disabled=true


# make sure player wants to destroy building
func _on_prompt_window_yes() -> void:
	building_manager.destroy_building(selected_building)
	sfx_player.stream=destroy_sound
	sfx_player.play()
	_update_owned_buildings()
	prompt_window.visible=false
	owned_item_list.deselect_all()
	build_button.disabled=true

# cancel destroying building
func _on_prompt_window_no() -> void:
	prompt_window.visible=false


#exit building menu and unpause game
func _on_exit_button_pressed() -> void:
	get_tree().paused=false
	queue_free()

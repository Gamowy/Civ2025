extends Control
class_name ActionMenu

@onready var actions_list = $Center/CenterContainer/PanelContainer/HBoxContainer/VBoxActions/ActionsList
@onready var actions_list_scrollbar = $Center/CenterContainer/PanelContainer/HBoxContainer/VBoxActions/ActionsList.get_v_scroll_bar()

@onready var description_label : Label = $Center/CenterContainer/PanelContainer/HBoxContainer/VBoxInfo/Description
@onready var gold_cost_label : Label = $Center/CenterContainer/PanelContainer/HBoxContainer/VBoxInfo/HBoxCostInfo/VBoxContainer/HBoxGold/GoldCost
@onready var wood_cost_label : Label =  $Center/CenterContainer/PanelContainer/HBoxContainer/VBoxInfo/HBoxCostInfo/VBoxContainer/HBoxWood/WoodCost
@onready var stone_cost_label : Label = $Center/CenterContainer/PanelContainer/HBoxContainer/VBoxInfo/HBoxCostInfo/VBoxContainer/HBoxStone/StoneCost
@onready var steel_cost_label : Label = $Center/CenterContainer/PanelContainer/HBoxContainer/VBoxInfo/HBoxCostInfo/VBoxContainer2/HBoxContainer/SteelCost
@onready var food_cost_label : Label = $Center/CenterContainer/PanelContainer/HBoxContainer/VBoxInfo/HBoxCostInfo/VBoxContainer2/HBoxContainer2/FoodCost

@onready var action_button : Button = $Center/CenterContainer/PanelContainer/HBoxContainer/VBoxInfo/ActionButton

signal exit_actions_menu
signal action_bought(action_name: String)

# Holds all possible actions
var actions_array : Array[ActionBaseClass] = [
	preload("res://scenes/actions/build_city_action.tscn").instantiate(),
	preload("res://scenes/actions/city_repair_action.tscn").instantiate(),
	preload("res://scenes/actions/heal_units_action.tscn").instantiate(),
	preload("res://scenes/actions/spy_action.tscn").instantiate()
]
# Holds currently selected action
var selected_action: ActionBaseClass
var player: Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for action in actions_array:
		actions_list.add_item(action.action_name, load(action.action_picture))

func _exit() -> void:
	exit_actions_menu.emit()
	_reset_action_info()
	
# Enables scrolling actions list by dragging 
func _on_scroll_actions_list(event: InputEvent) -> void:
	if event is InputEventScreenDrag:
		actions_list_scrollbar.value-=event.relative.y

func _on_exit_button_pressed() -> void:
	_exit()

func _display_action_info()->void:
	description_label.text = selected_action.action_description
	gold_cost_label.text = str(selected_action.gold_cost)
	wood_cost_label.text = str(selected_action.wood_cost)
	stone_cost_label.text = str(selected_action.stone_cost)
	steel_cost_label.text = str(selected_action.steel_cost)
	food_cost_label.text = str(selected_action.food_cost)

func _reset_action_info()->void:
	actions_list.deselect_all()
	action_button.disabled = true
	description_label.text = ""
	gold_cost_label.text = str("0")
	wood_cost_label.text = str("0")
	stone_cost_label.text = str("0")
	steel_cost_label.text = str("0")
	food_cost_label.text = str("0")

func can_player_use_action() -> bool:
	player = get_tree().get_first_node_in_group("players").current_player
	if (player.gold>=selected_action.gold_cost and player.wood>=selected_action.wood_cost 
	and player.stone>=selected_action.stone_cost and player.steel>=selected_action.steel_cost 
	and player.food>=selected_action.food_cost):
		return true
	else:
		return false

func _on_actions_list_item_selected(index: int) -> void:
	selected_action=actions_array[index]
	_display_action_info()
	action_button.disabled=true
	if can_player_use_action():
		action_button.disabled=false

func _on_action_button_pressed() -> void:
	player = get_tree().get_first_node_in_group("players").current_player
	player.gold -= selected_action.gold_cost
	player.wood -= selected_action.wood_cost
	player.stone -= selected_action.stone_cost
	player.steel -= selected_action.steel_cost
	player.food -= selected_action.food_cost
	action_bought.emit(selected_action.action_name)
	_exit()

## Use this to revert action cost if player cancels
func revert_last_action_cost() -> void:
	player.gold += selected_action.gold_cost
	player.wood += selected_action.wood_cost
	player.stone += selected_action.stone_cost
	player.steel += selected_action.steel_cost
	player.food += selected_action.food_cost

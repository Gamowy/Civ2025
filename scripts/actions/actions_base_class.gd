extends Node
class_name ActionBaseClass

@export_category("Action")
## Name of the action
@export var action_name: String = "Action"
## Action description
@export_multiline var action_description:String="No description."
## Picture representing action
@export_file() var action_picture
@export_group("Action cost")
## How many units of gold are required use this action
@export var gold_cost:int
## How many units of wood are required to use this action
@export var wood_cost:int
## How many units of stone are required to use this action
@export var stone_cost:int
## How many units of steel are required to use this action
@export var steel_cost:int
## How many units of food are required to use this action
@export var food_cost:int

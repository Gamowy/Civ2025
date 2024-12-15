extends Node
class_name Player

@export_category("Player info")
## Player's id and name
@export var player_id:int
@export var player_name:String
## Player's flag color
@export_color_no_alpha var flag_color:Color

@export_category("Resources")
## Starting number of gold units
@export var gold:int=100
## Starting number of wood units
@export var wood:int=10
## Starting number of stone units
@export var stone:int=10
## Starting number of steel units
@export var steel:int=10
## Starting number of food units
@export var food:int=10

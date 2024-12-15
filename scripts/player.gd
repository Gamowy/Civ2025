extends Node
class_name Player

func _init(id: int, playerName: String, flagColor: Color):
	player_id = id
	player_name = playerName
	flag_color = flagColor

@export_category("Player info")
## Player's id (must be unique), player's id's should start from 0 and increment
@export var player_id:int
## Player's name
@export var player_name:String = "Player"
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
## Fog of war uncovered cells
@export var uncovered_cells:Array[Vector2i]

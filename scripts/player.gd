extends Node
class_name Player

signal resource_value_changed(resource: String, value: int)
signal energy_value_changed(energy: int, max_energy: int)

@export_category("Player info")
## Player's id (must be unique), player's id's should start from 0 and increment
@export var player_id:int
## Player's name
@export var player_name:String = "Player"
## Player's flag color
@export_color_no_alpha var flag_color:Color

@export_category("Resources")
## Starting number of gold units
@export var gold:int=100:
	get:
		return gold
	set(value):
		gold = value
		resource_value_changed.emit("gold", value)
		
## Starting number of wood units
@export var wood:int=10:
	get:
		return wood
	set(value):
		wood = value
		resource_value_changed.emit("wood", value)
		
## Starting number of stone units
@export var stone:int=10:
	get:
		return stone
	set(value):
		stone = value
		resource_value_changed.emit("stone", value)
		
## Starting number of steel units
@export var steel:int=10:
	get:
		return steel
	set(value):
		steel = value
		resource_value_changed.emit("steel", value)
		
## Starting number of food units
@export var food:int=10:
	get:
		return food
	set(value):
		food = value
		resource_value_changed.emit("food", value)
## Energy determines how much a player can do durign their turn
@export var max_energy:int=3:
	get:
		return max_energy
	set(value):
		max_energy = value
		energy_value_changed.emit(energy, max_energy)
@export var energy:int=3:
	get:
		return energy
	set(value):
		energy = value
		energy_value_changed.emit(energy, max_energy)
## Fog of war uncovered cells
@export var uncovered_cells:Array[Vector2i]

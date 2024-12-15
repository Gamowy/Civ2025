extends Node

@export var players: Array[Player] = []
@export var number_of_players: int :
	get:
		return players.size()
@export var current_player_id: int = 0
@export var turn_number: int = 1

func _ready() -> void:
	child_entered_tree.connect(_player_added)
	child_exiting_tree.connect(_player_removed)

## Called every time a player is added
func _player_added(player):
	await player.ready
	players.append(player)

## Called every time a player is removed
func _player_removed(player):
	players.erase(player)

##  Use this to add player from within code
func add_player(player: Player) -> void:
	add_child(player)

## Use this to remove player from within code
func remove_player(player: Player) -> void:
	remove_child(player)

## Save fog of war uncovered cells for current player
func save_current_player_fog(cells: Array[Vector2i]) -> void:
	players[current_player_id].uncovered_cells = cells

## Get fog of war uncovered cells for current player
func get_current_player_fog() -> Array[Vector2i]:
	return players[current_player_id].uncovered_cells

## Switch current player
func switch_players() -> void:
	if current_player_id+1 > number_of_players:
		current_player_id = 0
		turn_number += 1
	else:
		current_player_id += 1

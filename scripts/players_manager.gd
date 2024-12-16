extends Node
class_name PlayersManager

@export var _players: Array[Player] = []
@export var _number_of_players: int :
	get:
		return _players.size()
	set(value):
		pass
@export var _current_player_id: int = 0
@export var _turn_number: int = 1

# Use this to access current player
var current_player: Player :
	get:
		return _players[_current_player_id]
	set(value):
		pass

signal current_player_resource_changed(resource: String, value: int)

func _ready() -> void:
	child_entered_tree.connect(_player_added)
	child_exiting_tree.connect(_player_removed)

## Called every time a player is added
func _player_added(player):
	await player.ready
	_players.append(player)
	player.resource_value_changed.connect(on_resource_value_changed)
	
## Called every time a player is removed
func _player_removed(player):
	_players.erase(player)

##  Use this to add player from within code
func add_player(player: Player) -> void:
	add_child(player)
	
## Use this to remove player from within code
func remove_player(player: Player) -> void:
	remove_child(player)

## Save fog of war uncovered cells for current player
func save_current_player_fog(cells: Array[Vector2i]) -> void:
	_players[_current_player_id].uncovered_cells = cells

## Switch current player
func switch_players() -> void:
	if _current_player_id+1 < _number_of_players:
		_current_player_id += 1
	else:
		_current_player_id = 0
		_turn_number += 1

func on_resource_value_changed(resource: String, value: int) -> void:
	current_player_resource_changed.emit(resource, value)

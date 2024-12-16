extends Node
class_name PlayersManager
const player_scene = preload("res://scenes/player.tscn")

@export_storage var players: Array[Player] = []
@export_storage var number_of_players: int :
	get:
		return players.size()
	set(value):
		pass
@export_storage var current_player_id: int = 0
@export_storage var turn_number: int = 1

# Use this to access current player
var current_player: Player :
	get:
		return players[current_player_id]
	set(value):
		pass

signal current_player_resource_changed(resource: String, value: int)

func _ready() -> void:
	child_entered_tree.connect(_player_added)
	child_exiting_tree.connect(_player_removed)

## Called every time a player is added
func _player_added(player):
	await player.ready
	players.append(player)
	player.resource_value_changed.connect(on_resource_value_changed)
	
## Called every time a player is removed
func _player_removed(player):
	players.erase(player)

##  Use this to add player from within code
func add_player(playerId: int, playerName: String, flagColor: Color) -> void:
	var new_player: Player = player_scene.instantiate()
	new_player.player_id = playerId
	new_player.player_name = playerName
	new_player.flag_color = flagColor
	add_child(new_player)
	
## Save fog of war uncovered cells for current player
func save_current_player_fog(cells: Array[Vector2i]) -> void:
	players[current_player_id].uncovered_cells = cells

## Switch current player
func switch_players() -> void:
	if current_player_id+1 < number_of_players:
		current_player_id += 1
	else:
		current_player_id = 0
		turn_number += 1
		
## Use this to remove all players (used when loading save)
func clear_players() -> void:
	for player in self.get_children():
		remove_child(player)
		player.queue_free()

func reload_player(saved_player: Player) -> void:
	add_player(saved_player.player_id, saved_player.player_name, saved_player.flag_color)
	players[players.size()-1].gold = saved_player.gold
	players[players.size()-1].wood = saved_player.wood
	players[players.size()-1].stone = saved_player.stone
	players[players.size()-1].steel = saved_player.steel
	players[players.size()-1].food = saved_player.food
	players[players.size()-1].uncovered_cells = saved_player.uncovered_cells

func on_resource_value_changed(resource: String, value: int) -> void:
	current_player_resource_changed.emit(resource, value)

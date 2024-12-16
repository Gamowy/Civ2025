extends Node2D
class_name Main

# Everything below needs to be saved in save_game() func.
# All properties annotated with @export will be saved
# ---------------------------------------------------------------------
# Contains data about players
@onready var players_manager = $PlayersManager

# Contains data for map layers
@onready var map_layer:MapLayer=$Map/MapLayer
@onready var resource_layer:ResourceLayer = $"Map/ResourceLayer"
@onready var city_layer = $"Map/CityLayer"
# ---------------------------------------------------------------------
@onready var user_interface = $UILayer/UserInterface
@onready var fog_thick_layer:FogThickLayer = $"Map/FogThickLayer"
@onready var camera=$Camera
var previous_cell:Vector2=Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	map_layer.generate_map()
	resource_layer.generate_resources(map_layer)
	fog_thick_layer.generate_fog(map_layer)
	#Set camera movement boundary
	camera.set_camera_boundary(Vector2(map_layer.width,map_layer.height))
	initGame()

func initGame() -> void:
	# TEST
	players_manager.add_player(Player.new(0, "Andrzej", Color.WHITE))
	players_manager.add_player(Player.new(1, "Adam", Color.RED))
	city_layer.add_city(Vector2i(10, 10), players_manager._players[0])
	city_layer.add_city(Vector2i(30, 15), players_manager._players[0])
	city_layer.add_city(Vector2i(50, 20), players_manager._players[1])
	city_layer.add_city(Vector2i(10, 25), players_manager._players[1])
	setup_current_player()

# Mouse input on map
func _unhandled_input(event: InputEvent) -> void:

	if event is InputEventScreenTouch:
		var global_clicked=get_global_mouse_position()
		if event.is_pressed():
			var pos_clicked=map_layer.local_to_map(to_local(global_clicked))
			map_layer.set_cell(previous_cell,map_layer.get_cell_source_id(previous_cell),map_layer.get_cell_atlas_coords(previous_cell),0)
			map_layer.set_cell(pos_clicked,map_layer.get_cell_source_id(pos_clicked),map_layer.get_cell_atlas_coords(pos_clicked),1)			
			previous_cell=pos_clicked
			
			print("clicked tile: "+str(pos_clicked)+" "+map_layer.terrain_dict.find_key(map_layer.get_cell_atlas_coords(pos_clicked))+
			", resource: "+resource_layer.resource_dict.find_key(resource_layer.get_cell_atlas_coords(pos_clicked))+
			", fog: "+fog_thick_layer.fog_dict.find_key(fog_thick_layer.get_cell_atlas_coords(pos_clicked)))			


func save_game():
	var save_data = FileAccess.open("user://save1.dat", FileAccess.WRITE)
	# Store data about players
	save_data.store_var(players_manager, true)
		
	# Store data about map and resources
	save_data.store_var(map_layer, true)
	save_data.store_var(resource_layer, true)
	
	# Store data about cities
	save_data.store_var(city_layer, true)

func setup_current_player() -> void:
	var player: Player = players_manager.current_player
	fog_thick_layer.generate_fog()
	fog_thick_layer.restore_uncovered_cells(player.uncovered_cells)
	city_layer.switch_city_fog(player)
	user_interface.update_ui("turn_label", player.player_name)
	user_interface.update_ui("gold", str(player.gold))
	user_interface.update_ui("wood", str(player.wood))
	user_interface.update_ui("stone", str(player.stone))
	user_interface.update_ui("steel", str(player.steel))
	user_interface.update_ui("food", str(player.food))
	

# UI Layer signal handlers
func _on_ui_layer_end_player_turn() -> void:
	players_manager.save_current_player_fog(fog_thick_layer.get_uncovered_cells())
	players_manager.switch_players()
	setup_current_player()

# PlayerManager signal handlers
func _on_players_manager_current_player_resource_changed(resource: String, value: int) -> void:
	user_interface.update_ui(resource, str(value))
	

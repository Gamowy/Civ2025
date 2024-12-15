extends Node2D

# Everything below needs to be saved in save_game() func.
# All properties annotated with @export will be saved
# ---------------------------------------------------------------------
# Number of turns passed (incremented after each player's turn)
var turn_count: int
# Number of players
var number_of_players: int
# Id of player in control
var current_player_id: int

# Contains data for players
@onready var players = $Players

# Contains data for map layers
@onready var map_layer:MapLayer=$Map/MapLayer
@onready var resource_layer:ResourceLayer = $"Map/ResourceLayer"
@onready var fog_thick_layer:FogThickLayer = $"Map/FogThickLayer"
@onready var city_layer = $"Map/CityLayer"
# ---------------------------------------------------------------------

@onready var camera=$Camera
var previous_cell:Vector2=Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	map_layer.generate_map()
	resource_layer.generate_resources(map_layer)
	fog_thick_layer.generate_fog(map_layer)
	#Set camera movement boundary
	camera.set_camera_boundary(Vector2(map_layer.width,map_layer.height))
	
	# TEST
	var player1=$Players/Player1
	city_layer.add_city(Vector2i(10, 10), player1)
	city_layer.add_city(Vector2i(30, 15), player1)
	city_layer.add_city(Vector2i(50, 20), player1)
	city_layer.add_city(Vector2i(10, 25), player1)

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
	
	# Store number of turns and current player id
	save_data.store_var(turn_count)
	save_data.store_var(current_player_id)
	
	# Store data for each player
	var players_data = []
	for player in self.get_children():
		if player is Player:
			players_data.append(player)
	save_data.store_var(players_data, true)
		
	# Store data about map and resources
	save_data.store_var(map_layer, true)
	save_data.store_var(resource_layer, true)
	
	# Store data about cities
	
		

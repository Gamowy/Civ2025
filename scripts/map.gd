extends Node2D


@onready var map_layer=$TileMap/MapLayer
@onready var resource_layer=$TileMap/ResourceLayer
var previous_cell:Vector2=Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	map_layer.generate_map()
	resource_layer.generate_resources(map_layer)


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		var global_clicked=get_global_mouse_position()
		if event.is_pressed():
			var pos_clicked=map_layer.local_to_map(to_local(global_clicked))
			map_layer.set_cell(previous_cell,map_layer.get_cell_source_id(previous_cell),map_layer.get_cell_atlas_coords(previous_cell),0)
			map_layer.set_cell(pos_clicked,map_layer.get_cell_source_id(pos_clicked),map_layer.get_cell_atlas_coords(pos_clicked),1)
			previous_cell=pos_clicked
			
			print("clicked tile: "+str(pos_clicked)+" "+map_layer.terrain_dict.find_key(map_layer.get_cell_atlas_coords(pos_clicked))+
			", resoruce: "+resource_layer.resource_dict.find_key(resource_layer.get_cell_atlas_coords(pos_clicked)))			

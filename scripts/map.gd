extends Node2D


@onready var map_layer:MapLayer=$Map/MapLayer
@onready var resource_layer:ResourceLayer=$Map/ResourceLayer
@onready var fog_thick_layer:FogThickLayer=$Map/FogThickLayer
var previous_cell:Vector2=Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	map_layer.generate_map()
	resource_layer.generate_resources(map_layer)
	fog_thick_layer.generate_fog(map_layer)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		var global_clicked=get_global_mouse_position()
		if event.is_pressed():
			var pos_clicked=map_layer.local_to_map(to_local(global_clicked))
			map_layer.set_cell(previous_cell,map_layer.get_cell_source_id(previous_cell),map_layer.get_cell_atlas_coords(previous_cell),0)
			map_layer.set_cell(pos_clicked,map_layer.get_cell_source_id(pos_clicked),map_layer.get_cell_atlas_coords(pos_clicked),1)
			
			#fog_thick_layer.set_cell(previous_cell,map_layer.get_cell_source_id(previous_cell),fog_thick_layer.get_cell_atlas_coords(previous_cell),0)
			#fog_thick_layer.set_cell(pos_clicked,map_layer.get_cell_source_id(pos_clicked),fog_thick_layer.get_cell_atlas_coords(pos_clicked),1)
			
			previous_cell=pos_clicked
			
			print("clicked tile: "+str(pos_clicked)+" "+map_layer.terrain_dict.find_key(map_layer.get_cell_atlas_coords(pos_clicked))+
			", resource: "+resource_layer.resource_dict.find_key(resource_layer.get_cell_atlas_coords(pos_clicked))+
			", fog: "+fog_thick_layer.fog_dict.find_key(fog_thick_layer.get_cell_atlas_coords(pos_clicked)))			

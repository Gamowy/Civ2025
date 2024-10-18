extends Node2D

@export var width:int=1024
@export var height:int=1024
@onready var tilemap=$TileMapLayer
var noise=FastNoiseLite.new()
var previous_cell:Vector2=Vector2(0,0)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	noise.noise_type=FastNoiseLite.TYPE_SIMPLEX
	noise.seed=randi()
	noise.fractal_octaves=5
	generate_map()

func generate_map()->void:
	for x in width:
		for y in height:
			var rand:int=int((noise.get_noise_2d(x,y)+1)*5)%5
			tilemap.set_cell(Vector2(x,y),0,Vector2(rand,0),0)

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		var global_clicked=get_global_mouse_position()
		if event.is_pressed():
			var pos_clicked=tilemap.local_to_map(to_local(global_clicked))
			var cells=tilemap.get_used_cells()
			tilemap.set_cell(previous_cell,tilemap.get_cell_source_id(previous_cell),tilemap.get_cell_atlas_coords(previous_cell),0)
			tilemap.set_cell(pos_clicked,tilemap.get_cell_source_id(pos_clicked),tilemap.get_cell_atlas_coords(pos_clicked),1)
			previous_cell=pos_clicked
			print(pos_clicked)
	
#func zoom():
	#if Input.is_action_just_released("wheel_down"):
		#$Camera2D.zoom.x += 0.25
		#$Camera2D.zoom.y += 0.25
	#if Input.is_action_just_released("wheel_up") and $Camera2D.zoom.x > 1 and $Camera2D.zoom.y > 1:
		#$Camera2D.zoom.x -= 0.25
		#$Camera2D.zoom.y -= 0.25

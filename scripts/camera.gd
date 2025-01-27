extends Camera2D

@export_category("Zoom")
## How fast the camera can zoom
@export var zoom_speed:float=0.1
## Maximum zoom
@export var max_zoom:float=4.5
## Minimum zoom
@export var min_zoom:float=1.5
## Can the camera zoom
@export var can_zoom:bool
@export_category("Pan")
## How fast the camera can pan
@export var pan_speed:float=1.0
## Can the camera pan
@export var can_pan:bool


var touch_points:Dictionary={}
var start_distance:float
var start_zoom

@warning_ignore("integer_division")
var boundary:Vector2=Vector2(64/2*MapInfo.CELL_SIZE+64/2*MapInfo.CELL_BOTTOM,
							32*MapInfo.CELL_HEIGHT)
var x_offset:int
var y_offset:int


func _ready() -> void:
	clamp_zoom(zoom)
	clamp_camera_position()
	
#sets cameras rightmost bottommost possible position point
#argument should be in number of tilemap cells
func set_camera_boundary(camera_boundary:Vector2):
	boundary.x=camera_boundary.x/2*MapInfo.CELL_SIZE+camera_boundary.x/2*MapInfo.CELL_BOTTOM
	boundary.y=camera_boundary.y*MapInfo.CELL_HEIGHT

func set_camera_position(new_pos:Vector2):
	global_position=new_pos
	clamp_camera_position()

func _input(event: InputEvent) -> void:
	scroll_zoom()
	if event is InputEventScreenTouch:
		handle_touch(event)
	if event is InputEventScreenDrag:
		handle_drag(event)

func handle_touch(event:InputEventScreenTouch)->void:
	if event.pressed:
		touch_points[event.index]=event.position
	else:
		touch_points.erase(event.index)
	
	if touch_points.size()==2:
		var touch_point_positions=touch_points.values()
		start_distance=touch_point_positions[0].distance_to(touch_point_positions[1])
		start_zoom=zoom
	elif touch_points.size()<2:
		start_distance=0
	
#make sure camera isn't out of bounds
func clamp_camera_position()->void:
	@warning_ignore("narrowing_conversion")
	x_offset=3*MapInfo.CELL_SIZE*max_zoom/zoom.x
	@warning_ignore("narrowing_conversion")
	y_offset=2*MapInfo.CELL_HEIGHT*max_zoom/zoom.y
	if global_position.x<0+x_offset:
		global_position.x=0+x_offset
	if global_position.y<0+y_offset:
		global_position.y=0+y_offset
	if global_position.x>boundary.x-x_offset:
		global_position.x=boundary.x-x_offset
	if global_position.y>boundary.y-y_offset:
		global_position.y=boundary.y-y_offset

func handle_drag(event:InputEventScreenDrag)->void:
	touch_points[event.index]=event.position
	if touch_points.size()==1:
		if can_pan:
			global_position-=event.relative*pan_speed/zoom.x
	elif touch_points.size()==2:
		var touch_point_positions=touch_points.values()
		var current_dist=touch_point_positions[0].distance_to(touch_point_positions[1])
		
		var zoom_factor=start_distance/current_dist
		if can_zoom:
			zoom=start_zoom/zoom_factor
	clamp_zoom(zoom)
	clamp_camera_position()

func clamp_zoom(new_zoom)->void:
	if new_zoom.x<min_zoom:
		zoom.x=min_zoom
	if new_zoom.y<min_zoom:
		zoom.y=min_zoom
	if new_zoom.x>max_zoom:
		zoom.x=max_zoom
	if new_zoom.y>max_zoom:
		zoom.y=max_zoom

#for debugging
func scroll_zoom()->void:
	if Input.is_action_just_released("wheel_up"):
		zoom.x += zoom_speed
		zoom.y += zoom_speed
	if Input.is_action_just_released("wheel_down") and zoom.x>0.1 and zoom.y>0.1:
		zoom.x -= zoom_speed
		zoom.y -= zoom_speed
	clamp_zoom(zoom)
	clamp_camera_position()

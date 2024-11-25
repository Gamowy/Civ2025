extends Camera2D

@export var zoom_speed:float=0.1
@export var pan_speed:float=1.0

@export var can_pan:bool
@export var can_zoom:bool

var touch_points:Dictionary={}
var start_distance:float
var start_zoom


func _input(event: InputEvent) -> void:
	scroll_zoom()
	if event is InputEventScreenTouch:
		handle_touch(event)
	if event is InputEventScreenDrag:
		handle_drag(event)

func handle_touch(event:InputEventScreenTouch):
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
	
func handle_drag(event:InputEventScreenDrag):
	touch_points[event.index]=event.position
	if touch_points.size()==1:
		if can_pan:
			offset-=event.relative*pan_speed/zoom.x
	elif touch_points.size()==2:
		var touch_point_positions=touch_points.values()
		var current_dist=touch_point_positions[0].distance_to(touch_point_positions[1])
		
		var zoom_factor=start_distance/current_dist
		if can_zoom:
			zoom=start_zoom/zoom_factor
		limit_zoom(zoom)

func limit_zoom(new_zoom):
	if new_zoom.x<0.1:
		zoom.x=0.1
	if new_zoom.y<0.1:
		zoom.y=0.1
	if new_zoom.x>10:
		zoom.x=10
	if new_zoom.y>10:
		zoom.y=10
		
func scroll_zoom():
	if Input.is_action_just_released("wheel_up"):
		zoom.x += zoom_speed
		zoom.y += zoom_speed
	if Input.is_action_just_released("wheel_down") and zoom.x>0.1 and zoom.y>0.1:
		zoom.x -= zoom_speed
		zoom.y -= zoom_speed

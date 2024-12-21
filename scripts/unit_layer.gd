extends TileMapLayer
class_name UnitLayer

var global_clicked #= Vector2(0,0)
var pos_clicked # = Vector2(0,0)


func spawn_warrior():
	print("boom")
	var spawn_point = pos_clicked
	var world_position = map_to_local(spawn_point)
	var warrior = preload("res://scenes/Units/Warrior.tscn").instantiate()
	add_child(warrior)
	warrior.position = world_position
	
func _unhandled_input(event: InputEvent) -> void:
	#print("unit input")
	if event is InputEventScreenTouch:
		global_clicked = get_global_mouse_position()
		if event.is_pressed():
			pos_clicked = local_to_map(to_local(global_clicked))
			#pos_clicked.x -= 1

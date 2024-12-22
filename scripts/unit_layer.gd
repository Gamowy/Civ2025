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
			pos_clicked.x += 1
			pos_clicked.y -= 1

func spawn_spearman():
	var spawn_point = pos_clicked
	var world_position = map_to_local(spawn_point)
	var spearman = preload("res://scenes/Units/Spearman.tscn").instantiate()
	add_child(spearman)
	spearman.position = world_position
	
func spawn_archer():
	var spawn_point = pos_clicked
	var world_position = map_to_local(spawn_point)
	var archer = preload("res://scenes/Units/Archer.tscn").instantiate()
	add_child(archer)
	archer.position = world_position
	
func spawn_archmage():
	var spawn_point = pos_clicked
	var world_position = map_to_local(spawn_point)
	var archmage = preload("res://scenes/Units/ArchMage.tscn").instantiate()
	add_child(archmage)
	archmage.position = world_position
	
func spawn_cavalry():
	var spawn_point = pos_clicked
	var world_position = map_to_local(spawn_point)
	var cavalry = preload("res://scenes/Units/Cavalry.tscn").instantiate()
	add_child(cavalry)
	cavalry.position = world_position
	
func spawn_crossbowman():
	var spawn_point = pos_clicked
	var world_position = map_to_local(spawn_point)
	var crossbowman = preload("res://scenes/Units/Crossbowman.tscn").instantiate()
	add_child(crossbowman)
	crossbowman.position = world_position
	
func spawn_halberdman():
	var spawn_point = pos_clicked
	var world_position = map_to_local(spawn_point)
	var halberdman = preload("res://scenes/Units/Halberdman.tscn").instantiate()
	add_child(halberdman)
	halberdman.position = world_position
	
func spawn_mage():
	var spawn_point = pos_clicked
	var world_position = map_to_local(spawn_point)
	var mage = preload("res://scenes/Units/Mage.tscn").instantiate()
	add_child(mage)
	mage.position = world_position
	
func spawn_scout():
	var spawn_point = pos_clicked
	var world_position = map_to_local(spawn_point)
	var scout = preload("res://scenes/Units/Scout.tscn").instantiate()
	add_child(scout)
	scout.position = world_position
	
func spawn_shieldman():
	var spawn_point = pos_clicked
	var world_position = map_to_local(spawn_point)
	var shieldman = preload("res://scenes/Units/Shieldman.tscn").instantiate()
	add_child(shieldman)
	shieldman.position = world_position

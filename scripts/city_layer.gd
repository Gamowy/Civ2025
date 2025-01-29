extends TileMapLayer
class_name CityLayer
const city_scene = preload("res://scenes/city.tscn")

## Emitted when a city is destroyed
signal city_destroyed()

var cities: Array[City] = []

func _ready() -> void:
	child_entered_tree.connect(_city_added)
	child_exiting_tree.connect(_city_removed)

## Called every time a new city is added to tilemap
func _city_added(city: City) -> void:
	await city.ready
	cities.append(city)

## Called every time a city is removed from tilemap
func _city_removed(city: City) -> void:
	cities.erase(city)

## Use this to create and add city from within code
func add_city(coords: Vector2i, city_owner: Player, city_name = "") -> void:
	var new_city: City = city_scene.instantiate()
	add_child(new_city)	
	if city_name != "":
		new_city.set_city_name(city_name)
	new_city.set_city_owner(city_owner)
	new_city.city_coords = coords
	new_city.position = map_to_local(coords)
	new_city.destroyed.connect(_on_city_destroyed)

func _on_city_destroyed(city:City):
	await city.tree_exited
	city_destroyed.emit()

## Creates the first city for given player
func create_initial_city(map_layer:MapLayer, resource_layer:ResourceLayer, city_owner:Player,max_attempts:int=100):
	var attempt=max_attempts
	var city_coords=get_coords_around_cities()
	var random_pos:Vector2i=Vector2i(randi_range(0, map_layer.width-1), randi_range(0, map_layer.height-1))
	if random_pos not in city_coords:
		var map_tile = map_layer.terrain_dict.find_key(map_layer.get_cell_atlas_coords(random_pos))
		if map_tile != "ocean" and map_tile != "empty":
			var resource=resource_layer.resource_dict.find_key(resource_layer.get_cell_atlas_coords(random_pos))
			if resource=="empty":
				add_city(random_pos,city_owner)
				return
	if attempt>0:
		create_initial_city(map_layer,resource_layer,city_owner,attempt-1)

## Returns city at given position, returns null if no city was found
func get_city_at_position(pos:Vector2)->City:
	var map_pos=local_to_map(pos)
	for city in cities:
		if city!=null and is_instance_valid(city):
			if local_to_map(city.position)==map_pos:
				return city
	return null

## Returns an array of coordinates close to existing cities
func get_coords_around_cities() -> Array[Vector2i]:
	var coords_array: Array[Vector2i]
	for city in cities:
		for x in range(-5, 5):
			for y in range(-5, 5):
				coords_array.append(Vector2i(city.city_coords.x + x, city.city_coords.y + y))
	return coords_array

## Use this to add already created city from within code
func add_existing_city(new_city: City) -> void:
	add_child(new_city)

## Use this to remove all cities (used when loading save)
func clear_cities() -> void:
	for city in self.get_children():
		remove_child(city)
		city.queue_free()
	
## Called when switching turns to switch fog for cities
func switch_city_fog(currentPlayer: Player) -> void:
	for city in cities:
		if city.city_owner == currentPlayer:
			city.fog_disperser_point_light.visible = true
		else:
			city.fog_disperser_point_light.visible = false

func get_resources_from_cities(currentPlayer: Player) -> void:
	for city in cities:
		if city.city_owner == currentPlayer:
			city.collect_resources()
			city.collect_building_boons()

func reload_city(saved_city: City) -> void:
	var players_manager: PlayersManager = get_tree().get_first_node_in_group("players")
	var saved_city_owner: Player = players_manager.players[saved_city.city_owner.player_id]
	add_city(saved_city.city_coords, saved_city_owner, saved_city.city_name)
	cities[cities.size()-1].set_city_radius(saved_city.city_radius)
	cities[cities.size()-1].city_health = saved_city.city_health
	cities[cities.size()-1].max_city_health = saved_city.max_city_health
	cities[cities.size()-1].building_limit = saved_city.building_limit
	cities[cities.size()-1].buildings = saved_city.buildings
	cities[cities.size()-1].city_level = saved_city.city_level
	cities[cities.size()-1].fog_disperser.set_radius(saved_city.city_radius)
	cities[cities.size()-1].texture = saved_city.texture

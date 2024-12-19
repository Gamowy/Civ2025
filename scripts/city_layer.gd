extends TileMapLayer
class_name CityLayer
const city_scene = preload("res://scenes/city.tscn")

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

func reload_city(saved_city: City) -> void:
	var players_manager: PlayersManager = get_tree().get_first_node_in_group("players")
	var saved_city_owner: Player = players_manager.players[saved_city.city_owner.player_id]
	add_city(saved_city.city_coords, saved_city_owner, saved_city.city_name)
	cities[cities.size()-1].city_radius = saved_city.city_radius
	cities[cities.size()-1].city_health = saved_city.city_health
	cities[cities.size()-1].building_limit = saved_city.building_limit
	cities[cities.size()-1].buildings = saved_city.buildings

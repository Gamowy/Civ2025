extends TileMapLayer
class_name CityLayer
const city_scene = preload("res://scenes/city.tscn")

@export var cities: Array[City] = []

func _ready() -> void:
	child_entered_tree.connect(_city_added)
	child_exiting_tree.connect(_city_removed)

## Called every time a new city is added to tilemap
func _city_added(city):
	await city.ready
	var coords = local_to_map(to_local(city.global_position))
	cities.append(city)
	city.set_meta("city_coords", coords)

## Called every time a city is removed from tilemap
func _city_removed(city):
	cities.erase(city)

## Use this to add city from within code
func add_city(coords: Vector2i, city_owner: Player, city_name = "") -> void:
	var new_city: City = city_scene.instantiate()
	add_child(new_city)	
	if city_name != "":
		new_city.set_city_name(city_name)
	new_city.set_city_owner(city_owner)
	new_city.position = map_to_local(coords)
	
## Use this to remove city from within code
func remove_city(city: City) -> void:
	remove_child(city)
	
## Called when switching turns to switch fog for cities
func switch_city_fog(currentPlayer: Player):
	for city in cities:
		if city.city_owner == currentPlayer:
			city.fog_disperser_point_light.visible = true
		else:
			city.fog_disperser_point_light.visible = false

#pomysl jest taki zeby po utworzeniu miasto sprawdzalo okolice w danym promieniu
#czy znajduja sie jakies zasoby, jesli tak to wtedy produkcja danego surowca co ture
#zwieksza sie, w miescie mozna budowac budynki za surowce, ktore daja rozne korzysci
#w miescie mozna tez rekrutowac jednostki, wojownikow, pracownikow itd
#po nacisnieciu na miasto ma pojawic sie menu z zbudowanymi  w nim budynkami,
#informacje o produkcji, mozliwosc budowy budynkow i jednostek
#wrogie jednostki moglyby zaatakowac miasto i je zniszczyc jesli jego punkty
#wytrzymalosci spadna do 0.

extends Sprite2D
class_name City

@onready var name_label:Label=$Label
@onready var fog_disperser:CityFogDisperser=$CityFogDisperser
@onready var fog_disperser_point_light = $CityFogDisperser/PointLight2D
@onready var resource_scan_area:Area2D=$Area2D
@onready var resource_scan_area_shape:CircleShape2D=$Area2D/CollisionShape2D.shape
@onready var city_menu: CanvasLayer = $City_Menu
@onready var flag:Sprite2D=$CityFlag
var default_city_names = ["Gliwice", "Katowice", "Tychy", "Częstochowa", "Zabrze", "Mikołów", "Chorzów", "Ruda Śląska", "Sosnowiec", "Orzesze"]

@export_category("City")
## The city's name
@export var city_name:String=default_city_names.pick_random()
## Radius of the city's visibility and resource harvesting regions
@export var city_radius:int=5
## The city's HP
@export var city_health:int=100
## Maximum number of buildings that can be built in this city
@export var building_limit:int=5
## How many units of gold the city produces per turn
@export var gold_production:int=1
## How many units of food the city produces per turn
@export var food_production:int=1
## How many units of wood the city produces per turn
@export var wood_production:int=1
## How many units of stone the city produces per turn
@export var stone_production:int=1
## How many units of steel the city produces per turn
@export var steel_production:int=1
## Status of city
@export var city_level:int=0

@export_storage var city_owner: Player
@export_storage var city_coords: Vector2i
@export_storage var buildings: Array[BuildingBaseClass]=[]
var resource_layer:ResourceLayer
var city_info_arr: Array
 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !(get_tree().get_first_node_in_group("resource_layer") is ResourceLayer):
		printerr(name+": Resource layer not found")
	else:
		resource_layer=get_tree().get_first_node_in_group("resource_layer")
	
	resource_scan_area_shape.radius=city_radius*MapInfo.CELL_SIZE

	name_label.text=city_name
	if city_owner!=null:#set flag color to match that of the player
		flag.modulate=city_owner.flag_color
	fog_disperser.set_radius(city_radius)
	fog_disperser.set_fog_disperser_enabled(true)
	fog_disperser_point_light.visible = true
	resource_scan_area.force_update_transform()

#collect resources produced by the city
#and give them to the city owner
func collect_resources()->void:
	city_owner.gold+=gold_production
	city_owner.wood+=wood_production
	city_owner.stone+=stone_production
	city_owner.steel+=steel_production
	city_owner.food+=food_production
	
#intended to be called at the start of every turn
#to collect resources etc, from owned buildings
func collect_building_boons()->void:
	for building in buildings:
		building.grant_boon(self)

func set_city_owner(new_city_owner:Player):
	city_owner=new_city_owner
	flag.modulate=new_city_owner.flag_color
	
func set_city_name(new_city_name: String):
	city_name = new_city_name
	name_label.text = new_city_name

#scan city area for resources, check type and increase production for found resources
func _on_area_2d_body_shape_entered(body_rid: RID, _body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	var cell:Vector2i=(resource_layer.get_coords_for_body_rid(body_rid))
	var resource_type:String=resource_layer.get_cell_tile_data(cell).get_custom_data("resource_type")
	match resource_type:
		"food":food_production+=1
		"wood":wood_production+=1
		"stone":stone_production+=1
		"steel":steel_production+=1

func update_city_info() -> void:
	var buildings_gold_production = 0
	var buildings_wood_production = 0
	var buildings_stone_production = 0
	var buildings_steel_production = 0
	var buildings_food_production = 0
	
	for building in buildings:
		buildings_gold_production += building.gold_production
		buildings_wood_production += building.wood_production
		buildings_stone_production += building.stone_production
		buildings_steel_production += building.steel_production
		buildings_food_production += building.food_production
	
	city_info_arr = [
		"City radius: "+str(city_radius), 
		"HP: "+str(city_health), 
		"Gold production: "+str(gold_production + buildings_gold_production), 
		"Food production: "+str(food_production + buildings_food_production), 
		"Wood production: "+str(wood_production + buildings_wood_production), 
		"Stone production: "+str(stone_production + buildings_stone_production), 
		"Steel production: "+str(steel_production + buildings_steel_production)
		]
	var i = 0
	for property in city_info_arr:
		city_menu.editTextOfButton(i, str(city_info_arr[i]))
		i+=1	

func _on_touch_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	var current_player: Player = get_tree().get_first_node_in_group("players").current_player
	if event is InputEventScreenTouch and event.is_pressed() and current_player == city_owner:
		#Nadanie nazwy menu - nazwa miasta
		#Oraz dodanie informacji o tym mieście do menu
		city_menu.menuName(city_name)
		update_city_info()
		city_menu.windowPopup()

## Called when new city first appears on map
func _on_city_fog_disperser_city_entered(coords: Vector2i) -> void:
	var current_player: Player = get_tree().get_first_node_in_group("players").current_player
	var fog_layer: FogThickLayer= get_tree().get_first_node_in_group("fog")
	city_owner.uncovered_cells.append(coords)
	if current_player == city_owner:
		fog_layer.restore_uncovered_cells(current_player.uncovered_cells)

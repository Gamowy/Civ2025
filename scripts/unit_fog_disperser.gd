#Zeby dodac np. jednostka mogla odkrywac mgle trzeba
#dolaczyc scene fog_disperser.tscn do sceny jednostki,
#ustawic promien widocznosci w inspektorze wlasciwosci (albo w kodzie-
#w przypadku ustawnia z kodu trzeba uzyc metod set_radius)
#i powinno dzialac

#Zeby jednostka/budynek itp nie byly widoczne przez 'cienka' mgle
#trzeba dodac material i ustwaic Light Mode - Light only
#CanvasItem->Material->New CanvasItemMaterial->Light Mode->wybrac Light Only

extends Node2D
class_name UnitFogDisperser

#@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D.shape

@onready var unit_thick_fog_disperser_shape:CircleShape2D=$UnitArea2D/UnitCollisionShape2D.shape
@onready var unit_thick_fog_disperser_area:Area2D=$UnitArea2D
@onready var unit_thin_fog_disperser:PointLight2D=$PointLight2D
@onready var unit = $".."

var fog_layer:FogThickLayer

@export_category("Fog Disperser")
## Radius of the visibility region around object
@export var radius:int=5
## Whether fog disperser is enabled or not
@export var fog_disperser_enabled:bool=true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#potrzebne jest odwolanie do wartswy z 'gesta' mgla zeby ja modyfikowac
	#dlatego zrobilem grupe 'fog' gdzie znajduje sie tylko ta warstwa gestej mgly
	#zeby byl do niej latwy dostep
	if !(get_tree().get_first_node_in_group("fog") is FogThickLayer):
		printerr(name+": Fog layer not found")
	else:
		fog_layer=get_tree().get_first_node_in_group("fog")
	
	set_radius(unit.rangeOfView)
	set_fog_disperser_enabled(fog_disperser_enabled)
	
#METHOD FOR SETTING RADIUS FROM CODE
func set_radius(new_radius:int):
	radius=new_radius
	unit_thick_fog_disperser_shape.radius=new_radius*MapInfo.CELL_SIZE
	unit_thin_fog_disperser.texture_scale=new_radius*2*float(MapInfo.CELL_SIZE)/unit_thin_fog_disperser.texture.get_height()#scale light texure

#METHOD FOR SETTING DISPERSER ENABLED FROM CODE
func set_fog_disperser_enabled(is_enabled:bool)->void:
	fog_disperser_enabled=is_enabled
	unit_thick_fog_disperser_area.monitoring=fog_disperser_enabled
	unit_thin_fog_disperser.enabled=fog_disperser_enabled

func _on_area_2d_body_shape_entered(body_rid: RID, _body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	fog_layer.erase_cell(fog_layer.get_coords_for_body_rid(body_rid))

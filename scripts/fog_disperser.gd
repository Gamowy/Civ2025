#Zeby dodac np. jednostka mogla odkrywac mgle trzeba
#dolaczyc scene fog_disperser.tscn do sceny jednostki,
#ustawic promien widocznosci w inspektorze wlasciwosci (albo w kodzie)
#i powinno dzialac

#Zeby jednostka/budynek itp nie byly widoczne przez 'cienka' mgle
#trzeba dodac material i ustwaic Light Mode - Light only
#CanvasItem->Material->New CanvasItemMaterial->Light Mode->wybrac Light Only

extends Node2D
class_name FogDisperser

const CELL_SIZE:int=64

@onready var thick_fog_disperser_shape:CircleShape2D=$Area2D/CollisionShape2D.shape
@onready var thick_fog_disperser_area:Area2D=$Area2D
@onready var thin_fog_disperser:PointLight2D=$PointLight2D

var fog_layer:FogThickLayer

@export_category("Fog Disperser")
## Radius of the visibility region around object
@export var radius:int=5
## Whether fog disperser is enabled or not
@export var fog_disperser_enabled:bool=true:
	set(value):
		fog_disperser_enabled=value
		if(fog_disperser_enabled):
			thick_fog_disperser_area.monitoring=true
			thin_fog_disperser.enabled=true
		else:
			thick_fog_disperser_area.monitoring=false
			thin_fog_disperser.enabled=false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#potrzebne jest odwolanie do wartswy z 'gesta' mgla zeby ja modyfikowac
	#dlatego zrobilem grupe 'fog' gdzie znajduje sie tylko ta warstwa gestej mgly
	#zeby byl do niej latwy dostep
	if !(get_tree().get_first_node_in_group("fog") is FogThickLayer):
		printerr(name+": Fog layer not found")
	else:
		fog_layer=get_tree().get_first_node_in_group("fog")
	
	thick_fog_disperser_shape.radius=radius*CELL_SIZE
	thin_fog_disperser.texture_scale=radius*2*float(CELL_SIZE)/thin_fog_disperser.texture.get_height()#scale light texure


func _on_area_2d_body_shape_entered(body_rid: RID, _body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	fog_layer.erase_cell(fog_layer.get_coords_for_body_rid(body_rid))

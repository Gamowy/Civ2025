extends TileMapLayer
class_name MapLayer


var previous_cell:Vector2=Vector2(0,0)
var noise=FastNoiseLite.new()

@export_category("Map generation")
## Width of the map. Should be divisible by 16
@export_range(MapInfo.CHUNK_SIZE,640,MapInfo.CHUNK_SIZE) var width:int=MapInfo.CHUNK_SIZE*4
## Height of the map. Should be divisible by 16
@export_range(MapInfo.CHUNK_SIZE,640,MapInfo.CHUNK_SIZE)var height:int=MapInfo.CHUNK_SIZE*2
## Simplex noise seed, random by default
@export var map_seed:int=randi()
#terrain types and their position in tile set atlas
var terrain_dict:Dictionary={
	"desert":Vector2i(0,0),
	"grass":Vector2i(1,0),
	"mountain":Vector2i(2,0),
	"snow":Vector2i(3,0),
	"ocean":Vector2i(4,0),
	"empty":Vector2i(-1,-1)}

func _ready() -> void:
	noise.noise_type=FastNoiseLite.TYPE_SIMPLEX
	noise.seed=map_seed
	noise.fractal_octaves=5

func generate_map()->void:
	for x in width:
		for y in height:
			var rand:int=int((noise.get_noise_2d(x,y)+1)*5)%5
			set_cell(Vector2(x,y),0,Vector2(rand,0),0)
					
func reload(saved_map_layer: MapLayer):
	self.noise = saved_map_layer.noise
	self.width = saved_map_layer.width
	self.height = saved_map_layer.height
	self.tile_map_data = saved_map_layer.tile_map_data
	

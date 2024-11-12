extends TileMapLayer
class_name MapLayer

const CHUNK_SIZE:int=16

var noise=FastNoiseLite.new()
var previous_cell:Vector2=Vector2(0,0)

@export_category("Map generation")
## Width of the map. Should be divisible by 16
@export_range(CHUNK_SIZE,640,CHUNK_SIZE) var width:int=CHUNK_SIZE*4
## Height of the map. Should be divisible by 16
@export_range(CHUNK_SIZE,640,CHUNK_SIZE)var height:int=CHUNK_SIZE*2
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

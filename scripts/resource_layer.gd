extends TileMapLayer
class_name ResourceLayer

@export_storage var rng:RandomNumberGenerator=RandomNumberGenerator.new()

@export_category("Resource generation")
## Maximum number of resources that can be generated on a single chunk
@export_range(0,64,1) var resources_per_chunk:int=16
## Seed for generating resources, random by default
@export var resource_seed:int=randi()
#resource types and their position in tile set atlas
var resource_dict:Dictionary={
	"forest":Vector2i(0,0),
	"pineforest":Vector2i(1,0),
	"stone_grass":Vector2i(2,0),
	"stone_snow":Vector2i(3,0),
	"stone_desert":Vector2i(4,0),
	"ore_grass":Vector2i(5,0),
	"ore_snow":Vector2i(6,0),
	"ore_desert":Vector2i(7,0),
	"wheat":Vector2i(8,0),
	"fish":Vector2i(9,0),
	"sheep":Vector2i(10,0),
	"empty":Vector2i(-1,-1)}

func _ready() -> void:
	rng.seed=resource_seed
	
func set_seed(new_seed: String) -> void:
	resource_seed = hash(new_seed)
	rng.seed = resource_seed
	
#try to place given number of resources on each chunk
func generate_resources(map_layer:MapLayer)->void:
	var resources_to_place:int=resources_per_chunk
	var current_chunk=Vector2i(0,0)
	@warning_ignore("integer_division")
	for x in (map_layer.width/MapInfo.CHUNK_SIZE):
		@warning_ignore("integer_division")
		for y in (map_layer.height/MapInfo.CHUNK_SIZE):
			while resources_to_place>0:	
				resources_to_place-=1
				var rand:Vector2i
				rand.x=rng.randi_range(0,MapInfo.CHUNK_SIZE-1)+current_chunk.x*MapInfo.CHUNK_SIZE
				rand.y=rng.randi_range(0,MapInfo.CHUNK_SIZE-1)+current_chunk.y*MapInfo.CHUNK_SIZE
				var resoruce_name:String=draw_resource(map_layer.terrain_dict.find_key(map_layer.get_cell_atlas_coords(rand)))
				set_cell(rand,0,resource_dict[resoruce_name],0)
			current_chunk.y+=1
			resources_to_place=resources_per_chunk
		current_chunk.y=0
		current_chunk.x+=1

#get random resource from resources possible for given terrain type
func draw_resource(terrain_type:String):
	if terrain_type=="desert":
		var possible_resources=["stone_desert","ore_desert"]
		var resource_index:int=rng.randi_range(0,len(possible_resources)-1)
		return(possible_resources[resource_index])
	elif terrain_type=="grass":
		var possible_resources=["forest","stone_grass","ore_grass","wheat"]
		var resource_index:int=rng.randi_range(0,len(possible_resources)-1)
		return(possible_resources[resource_index])
	elif terrain_type=="mountain":
		return("sheep")
	elif terrain_type=="snow":
		var possible_resources=["pineforest","stone_snow","ore_snow"]
		var resource_index:int=rng.randi_range(0,len(possible_resources)-1)
		return(possible_resources[resource_index])
	elif terrain_type=="ocean":
		return("fish")
	else:
		return("empty")

func reload(saved_resource_layer: ResourceLayer) -> void:
	self.rng = saved_resource_layer.rng
	self.tile_map_data = saved_resource_layer.tile_map_data

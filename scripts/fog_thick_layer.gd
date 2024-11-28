#uwaga mgla ma Z Index=3, zeby nie bylo przez nia widac np jednostek albo budynkow
#powinny sie one znajdowac na nizszym Z Index (Najlepiej 2 bo na nizszych jest mapa i zasoby)
#jakby trzeba bylo wiecej warstw pomiedzy to trzeba bedzie dac mgle na wyzszy z index

extends TileMapLayer
class_name FogThickLayer

var map_layer:MapLayer

var fog_dict:Dictionary={"empty":Vector2i(-1,-1),"fog":Vector2i(0,0)}

func generate_fog(map_layer_arg:MapLayer=null)->void:
	if map_layer_arg!=null:
		self.map_layer=map_layer_arg
	for x in map_layer.width:
		for y in map_layer.height:
			set_cell(Vector2(x,y),0,Vector2(0,0),0)


func get_uncovered_cells()->Array[Vector2i]:
	var uncovered_cells:Array[Vector2i]=[]
	for x in map_layer.width:
		for y in map_layer.height:
			if Vector2i(x,y) not in get_used_cells():
				uncovered_cells.append(Vector2i(x,y))
	return(uncovered_cells)


#to be used when switching between players or loading a saved game
func restore_uncovered_cells(uncovered_cells:Array[Vector2i])->void:
	for cell in uncovered_cells:
		erase_cell(cell)

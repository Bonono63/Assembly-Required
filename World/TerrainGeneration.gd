class_name TerrainGeneration
extends Node

signal chunk_data_loaded

var seed : int
var chunk_position : Vector3i
var chunk : Chunk = Chunk.new()

func _init(_seed : int, _chunk_position : Vector3i = Vector3i(0,0,0)) -> void:
	seed = _seed
	chunk_position = _chunk_position
	generate()

func change_position(_chunk_position : Vector3i) -> void:
	chunk = Chunk.new()
	chunk_position = _chunk_position+Vector3i(1,1,1)
	generate()

# TODO return actual chunks
func get_chunk() -> Chunk:
	return chunk

# TODO properly setup noise and stuff to do things
func generate() -> void:
	var texture = NoiseTexture3D.new()
	var noise = FastNoiseLite.new()
	
	texture.depth = 32
	texture.height = 32
	texture.width = 32
	
	noise.seed = seed
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.fractal_type = FastNoiseLite.FRACTAL_FBM
	noise.offset = chunk_position*32
	
	texture.noise = noise
	
	# wait for chunk to generate
	await texture.changed
	
	var data = texture.get_data()
	
	for z in data.size():
		for x in data[z].get_width():
			for y in data[z].get_height():
				var color : Color = data[z].get_pixel(x,y)
				
				if color.v > 0.5:
					chunk.set_block_state(index_tools.pos_to_index(Vector3(x,y,z)), chunk.palette[chunk.get_or_create_blockstate(block_state.new(0))])
				else:
					chunk.set_block_state(index_tools.pos_to_index(Vector3(x,y,z)), chunk.palette[chunk.get_or_create_blockstate(block_state.new(1))])
	
	emit_signal("chunk_data_loaded")

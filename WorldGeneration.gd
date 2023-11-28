class_name WorldGeneration
extends Node

signal chunk_data_loaded

var seed : int
var chunk_position : Vector3i
var chunk : Chunk

enum block_types
{
	AIR,
	DIRT,
	GRASS,
	STONE,
}

func _init(_seed : int, _chunk_position : Vector3i):
	seed = _seed
	chunk_position = _chunk_position
	generate()

func change_position(_chunk_position):
	chunk_position = _chunk_position

# TODO return actual chunks
func get_chunk_data() -> Chunk:
	var chunk : Chunk = Chunk.new([],{})
	
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
	
	for image in data:
		pass
	
	emit_signal("chunk_data_loaded")

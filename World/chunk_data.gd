class_name Chunk_Data
extends Object

# length of unsigned 16 in bytes
const stride = 2

enum Blocks
{
	AIR,
	STONE,
	DIRT,
	GRASS,
}

var data : PackedByteArray


# Initialize the array
func _init():
	for i in 32768*2:
		data.append(0)


func get_index(data_index : int) -> int:
	return data.decode_u16((data_index*stride))


func set_index(data_index: int, palette_index : int) -> void:
	data.encode_u16((data_index*stride), palette_index)


func remove_entry(data_index : int) -> void:
	data.remove_at(data_index)

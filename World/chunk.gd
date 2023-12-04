class_name Chunk
extends Resource

const chunk_length = 32
const chunk_length_squared = 1024
const chunk_length_cubed = 32768

# stores all the block_states in the chunk
var palette : Array[block_state]
# stores the position of the block states within the chunk.
var data : Chunk_Data

func _init(_palette : Array[block_state], _data : Chunk_Data) -> void:
	palette.append(block_state.new(0))
	
	data = _data
	
	if !_palette.is_empty():
		palette = _palette
	
	set_block_state(chunk_length_cubed-1, block_state.new(0))
	
	# fill with random shit
	var index = chunk_length_cubed-1
	while index >= 0:
		set_block_state(index, block_state.new(randi_range(0,1)))
		index-=1
	


# TODO remove redundant block states from palette if applicable
func set_block_state(index : int, state : block_state) -> void:
	data.set_index(index, get_or_create_blockstate(state))

# Either returns the index of the stored blockstate from the palette
# or returns the index of the appended state
func get_or_create_blockstate(state : block_state) -> int:
	for index in palette.size():
		if palette[index].identifier == state.identifier and palette[index].properties == state.properties:
			return index
	
	palette.append(state)
	return palette.size()-1


# searches for the block state at the given position
func get_block_state(index : int) -> block_state:
	return palette[data.get_index(index)]


func get_index(index : int) -> int:
	return data.get_index(index)


# Find the key the closest position before the given key
#func find_least_key(index : int) -> int:
#	var least_index : int = 0
#	while index >= 0:
#		if data[index] != 0:
#			least_index = index
#			return least_index
#		index-=1
#	return least_index
#
#
#func find_greatest_key(index : int) -> int:
#	var greatest_index : int = chunk_length_cubed-1
#	while index < chunk_length_cubed:
#		if data[index] != 0:
#			greatest_index = index
#			return greatest_index
#		index+=1
#	return greatest_index


#func is_empty() -> bool:
#	if data.size() == 1 and get_block_state(chunk_length_cubed-1).identifier == 1:
#		return true
#	else:
#		return false

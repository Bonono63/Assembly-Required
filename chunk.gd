class_name Chunk
extends Node

const chunk_length = 32
const chunk_length_squared = 32*32
const chunk_length_cubed = 32*32*32

# stores all the block_states in the chunk
var palette : Array[block_state]
# stores the position of the block states within the chunk.
# we use the dictionary to store the END of the sequence of block states in order to make sure we
# we don't reuse end points and are able to easily check when we need to make a new end or insert
var data : Dictionary = {}


func _init(_palette : Array[block_state], _data : Dictionary) -> void:
	# initializes the chunk as all AIR
	data[chunk_length_cubed-1] = get_or_create_blockstate(block_state.new(1))
	#data[chunk_length_cubed-5] = get_or_create_blockstate(block_state.new(0))
	
	var index = chunk_length_cubed-1
	while index >= 0:
		var type = randi_range(0,1)
		set_block_state(index, block_state.new(type))
		
		index-=1
	
	if !_palette.is_empty():
		palette = _palette
	if !_data.is_empty():
		data = _data


func set_block_state(index : int, state : block_state) -> void:
	
	#check if there is a state at the current position
	if index in data:
		
		#var other_keys_have_state : bool = false
		#
		#for key in data.keys():
		#	# make sure to exclude the current position during the search
		#	if data.get(key) == data.get(index) and key != index:
		#		other_keys_have_state = true
		#
		#if !other_keys_have_state:
		#	print("amongus")
		#		palette.erase(data.get(index))
		
		# find the index before the current position
		var before_index : int = index+1
		if before_index in data:
			# if there is a blockstate at that position only replace the current block state
			data.erase(before_index)
			data[index] = get_or_create_blockstate(state)
		else:
			# if there isn't a blockstate in the before position find the closest position
			# and copy to the before position and copy it
			var greatest = find_greatest_key(index)
			data[before_index] = data[greatest]
			data[index] = get_or_create_blockstate(state)
	else:
		if get_block_state(index) == state:
			return
		
		var before_index : int = index+1
		if data.has(before_index):
			if palette[data[before_index]].identifier == state.identifier and palette[data[before_index]].properties == state.properties:
				data.erase(before_index)
		
		var greatest = find_greatest_key(index)
		if greatest != null and palette[data[greatest]] == state:
			return
		else:
			data[index] = get_or_create_blockstate(state)


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
	if index < chunk_length_cubed:
		# returns the block state if the given position is also the end of the sequence
		if data.has(index):
			return palette[data.get(index)]
		# else search for the closest position
		else:
			return palette[data.get(find_greatest_key(index))]
	
	printerr("position of get_block_state was out of bounds")
	return null


# Find the key the closest position before the given key
func find_least_key(index : int) -> int:
	var least_index : int = 0
	for key in data.keys():
		if key < index and index > least_index:
			least_index = key
	return least_index


func find_greatest_key(index : int) -> int:
	var greatest_index : int = chunk_length_cubed-1
	for key in data.keys():
		if key > index and key < greatest_index:
			greatest_index = key
	
	return greatest_index


func is_empty() -> bool:
	if data.size() == 1 and get_block_state(chunk_length_cubed-1).identifier == 0:
		return true
	else:
		return false

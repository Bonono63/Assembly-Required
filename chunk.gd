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
	data[chunk_length_cubed] = get_or_create_blockstate(block_state.new(0))
	
	palette = _palette
	if !_data.is_empty():
		data = _data

func set_block_state_pos(pos : Vector3i, state : block_state) -> void:
	
	var index = pos_to_index(pos)
	
	#check if there is a state at the current position
	if data.has(index):
		
		var other_keys_have_state : bool = false
		
		for key in data.keys():
			# make sure to exclude the current position during the search
			if data.get(key) == data.get(index) and key != index:
				other_keys_have_state = true
		
		if !other_keys_have_state:
			palette.erase(data.get(index))
		
		# find the index before the current position
		var before_index : int = index-1
		if data.has(before_index):
			# if there is a blockstate at that position only replace the current block state
			data[index] = get_or_create_blockstate(state)
		else:
			# if there isn't a blockstate in the before position find the closest position
			# and copy to the before position and copy it
			var greatest = find_greatest_key(index)
			data[before_index] = data[greatest]
			data[index] = get_or_create_blockstate(state)
	else:
		var greatest = find_greatest_key(index)
		var before_index : int = index-1
		
		if data.has(before_index):
			if palette[data.get(before_index)] == state:
				data.erase(before_index)
		
		if palette[data.get(greatest)] == state:
			return
		else:
			data[index] = get_or_create_blockstate(state)

func set_block_state(index : int, state : block_state) -> void:
	
	#check if there is a state at the current position
	if data.has(index):
		
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
		var before_index : int = index-1
		if data.has(before_index):
			# if there is a blockstate at that position only replace the current block state
			data[index] = get_or_create_blockstate(state)
		else:
			# if there isn't a blockstate in the before position find the closest position
			# and copy to the before position and copy it
			var greatest = find_greatest_key(index)
			data[before_index] = data[greatest]
			data[index] = get_or_create_blockstate(state)
	else:
		var greatest = find_greatest_key(index)
		var before_index : int = index-1
		
		if data.has(before_index):
			if palette[data.get(before_index)] == state:
				data.erase(before_index)
		
		if palette[data.get(greatest)] == state:
			return
		else:
			data[index] = get_or_create_blockstate(state)

# Either returns the index of the stored blockstate from the palette
# or returns the index of the appended state
func get_or_create_blockstate(state : block_state) -> int:
	if palette.has(state):
		return palette.find(state)
	else:
		palette.append(state)
		return palette.size()

# searches for the block state at the given position
func get_block_state_pos(pos : Vector3i) -> block_state:
	var index = pos_to_index(pos)
	if index < chunk_length_cubed:
		# returns the block state if the given position is also the end of the sequence
		if data.has(index):
			return palette[data.get(index)]
		# else search for the closest position
		else:
			return palette[data.get(find_greatest_key(index))]
	
	printerr("position of get_block was out of bounds")
	return null

# searches for the block state at the given position
func get_block_state(index : int) -> block_state:
	if index < chunk_length_cubed:
		# returns the block state if the given position is also the end of the sequence
		if data.has(index):
			return palette[data.get(index)]
		# else search for the closest position
		else:
			return palette[data.get(find_greatest_key(index))]
	
	printerr("position of get_block was out of bounds")
	return null

# Find the key the closest position before the given key
func find_least_key(index : int) -> int:
	var least_index : int = 0
	for key in data.keys():
		if key < index and index > least_index:
			least_index = key
	return least_index

func find_greatest_key(index : int) -> int:
	var greatest_index : int = chunk_length_cubed
	for key in data.keys():
		if key > index and key < greatest_index:
			greatest_index = key
	
	return greatest_index

func get_empty() -> bool:
	if data.size() == 1 and data[chunk_length_cubed] == block_state.new(0):
		return true
	else:
		return false

func index_to_pos(i : int) -> Vector3i:
	@warning_ignore("integer_division")
	return Vector3i(i/(32*32),(i/32) % 32,i % 32)

func pos_to_index(pos : Vector3i) -> int:
	return (pos.x*32*32)+(pos.y*32)+pos.z

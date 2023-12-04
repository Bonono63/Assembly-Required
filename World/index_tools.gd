class_name index_tools
extends Node

static func index_to_pos(i : int, scale : int = 32) -> Vector3:
	@warning_ignore("integer_division")
	return Vector3(i % scale, (i/scale) % scale, i/(scale*scale))

static func pos_to_index(pos : Vector3) -> int:
	return pos.x+(pos.y*32)+(pos.z*32*32)

static func get_above_pos(index : int) -> int:
	var pos : Vector3 = index_to_pos(index)
	pos.y+=1
	if pos.y < 32:
		return pos_to_index(pos)
	else:
		return -1;

static func get_below_pos(index : int) -> int:
	var pos : Vector3 = index_to_pos(index)
	pos.y-=1
	if pos.y >= 0:
		return pos_to_index(pos)
	else:
		return -1;

static func get_forward_pos(index : int) -> int:
	var pos : Vector3 = index_to_pos(index)
	pos.x+=1
	if pos.x < 32:
		return pos_to_index(pos)
	else:
		return -1;

static func get_backward_pos(index : int) -> int:
	var pos : Vector3 = index_to_pos(index)
	pos.x-=1
	if pos.x >= 0:
		return pos_to_index(pos)
	else:
		return -1;

static func get_left_pos(index : int) -> int:
	var pos : Vector3 = index_to_pos(index)
	pos.z-=1
	if pos.z >= 0:
		return pos_to_index(pos)
	else:
		return -1;

static func get_right_pos(index : int) -> int:
	var pos : Vector3 = index_to_pos(index)
	pos.z+=1
	if pos.z < 32:
		return pos_to_index(pos)
	else:
		return -1;

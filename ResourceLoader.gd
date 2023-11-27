extends Node

var generic_box : Array = Array([
	Vector3(-0.5, 0.5, 0.5), Vector3(0.5, 0.5, 0.5), Vector3(-0.5, -0.5, 0.5),
	Vector3(0.5, 0.5, 0.5), Vector3(0.5, -0.5, 0.5), Vector3(-0.5, -0.5, 0.5),
	Vector3(0.5, 0.5, -0.5), Vector3(-0.5, 0.5, -0.5), Vector3(0.5, -0.5, -0.5),
	Vector3(-0.5, 0.5, -0.5), Vector3(-0.5, -0.5, -0.5), Vector3(0.5, -0.5, -0.5),
	Vector3(0.5, 0.5, 0.5), Vector3(0.5, 0.5, -0.5), Vector3(0.5, -0.5, 0.5),
	Vector3(0.5, 0.5, -0.5), Vector3(0.5, -0.5, -0.5), Vector3(0.5, -0.5, 0.5),
	Vector3(-0.5, 0.5, -0.5), Vector3(-0.5, 0.5, 0.5), Vector3(-0.5, -0.5, -0.5),
	Vector3(-0.5, 0.5, 0.5), Vector3(-0.5, -0.5, 0.5), Vector3(-0.5, -0.5, -0.5),
	Vector3(0.5, 0.5, 0.5), Vector3(-0.5, 0.5, 0.5), Vector3(0.5, 0.5, -0.5),
	Vector3(-0.5, 0.5, 0.5), Vector3(-0.5, 0.5, -0.5), Vector3(0.5, 0.5, -0.5),
	Vector3(-0.5, -0.5, 0.5), Vector3(0.5, -0.5, 0.5), Vector3(-0.5, -0.5, -0.5),
	Vector3(0.5, -0.5, 0.5), Vector3(0.5, -0.5, -0.5), Vector3(-0.5, -0.5, -0.5)
])

var block_registry : Array[Block] = []
var un_greedable_list : Array[int] = []


# load all resources/assets
func _init():
	var err = register_blocks("")
	if err != 0:
		printerr("Couldn't register blocks error code: ", )

# read bock resources
func register_blocks(path : String) -> int:
	register_block(false, false, "Air", [], [])
	register_block(false, true, "Dirt", generic_box, generic_box)
	return 0

func register_block(_translucent : bool, _is_full : bool, _display_name : String, _model : Array, _collision_shape : Array):
	var block : Block = Block.new(block_registry.size(), _translucent, _is_full, _display_name, _model, _collision_shape)
	if !_is_full:
		un_greedable_list.append(block_registry.size())
	block_registry.append(block)

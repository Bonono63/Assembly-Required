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


# load all resources/assets
func _init():
	var err = register_blocks("")
	if err != 0:
		printerr("Couldn't register blocks error code: ", )

# read bock resources
func register_blocks(path : String) -> int:
	register_block(false, false, "Air")
	var dirt_material = StandardMaterial3D.new()
	dirt_material.albedo_texture = ImageTexture.create_from_image(Image.load_from_file("res://resources/dirt.png"))
	dirt_material.cull_mode = BaseMaterial3D.CULL_BACK
	dirt_material.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	register_block(false, true, "Dirt", generic_box, dirt_material, generic_box)
	register_block(false, true, "Stone", generic_box, dirt_material, generic_box)
	register_block(false, true, "Grass", generic_box, dirt_material, generic_box)
	return 0

func register_block(_translucent : bool = false, _is_full : bool = true, _display_name : String = "", _model : Array = [], _material : StandardMaterial3D = StandardMaterial3D.new(), _collision_shape : Array = []):
	var block : Block = Block.new(block_registry.size(), _translucent, _is_full, _display_name, _model, _material, _collision_shape)
	block_registry.append(block)

class_name block_state
extends Resource

var identifier : int
var properties : PackedByteArray = PackedByteArray([])


func _init(_identifier : int):
	identifier = _identifier


func _to_string():
	return str("id: ",identifier," properties: ",properties)


func get_full() -> bool:
	return GlobalResourceLoader.block_registry[identifier].is_full


func get_translucent() -> bool:
	return GlobalResourceLoader.block_registry[identifier].translucent


func get_model() -> Array:
	return GlobalResourceLoader.block_registry[identifier].model


func get_collision_shape() -> Array:
	return GlobalResourceLoader.block_registry[identifier].collision_shape


func get_display_name() -> String:
	return GlobalResourceLoader.block_registry[identifier].display_name

func get_material() -> Material:
	return GlobalResourceLoader.block_registry[identifier].material

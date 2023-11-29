class_name block_state
extends Node

var identifier : int
var properties : PackedByteArray = PackedByteArray([])

func _init(_identifier : int):
	identifier = _identifier

func _to_string():
	return str("id: ",identifier," properties: ",properties)

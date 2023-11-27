class_name Chunk
extends Node

var data : Array[efficient_block_state]

func _init(_data : Array[efficient_block_state]):
	data = _data

func get_block_state(pos : Vector3i):
	pass

func set_block_state(pos : Vector3i, state : block_state):
	pass

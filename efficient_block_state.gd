class_name efficient_block_state
extends Node

var start : Vector3i
var end : Vector3i
var state : block_state

func _init(_start : Vector3i, _end : Vector3i, _state : block_state):
	start = _start
	end = _end
	state = _state

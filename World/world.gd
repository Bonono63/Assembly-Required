extends Node3D

signal reload_chunks

var seed : int

func _init() -> void:
	seed = randi()

func get_seed() -> int:
	return seed

func _ready() -> void:
	for entity in $entities.get_children():
		entity.seed = seed

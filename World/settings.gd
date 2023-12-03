extends Node

# fps lock
var target_fps : int = 165
# Radius of the sphere in which chunks are fully rendered
var render_radius : int = 4
# What is the length of the cube in which colliders are created
var player_collision_distance : int = 4

func _init():
	Engine.max_fps = target_fps

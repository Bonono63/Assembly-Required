extends Node

var target_fps : int = 165
var render_radius : int = 4

func _ready():
	Engine.max_fps = target_fps

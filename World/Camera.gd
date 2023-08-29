extends Node3D

@export var mouse_sensitivity = 1.0

var x = 0
var y = 0

var inverse_x : bool = false
var inverse_y : bool = false

var camera_number : int = 0
var current_camera : Camera3D

func _ready():
	get_window().focus_entered.connect(Callable(self,"on_window_selected"))
	get_window().focus_exited.connect(Callable(self,"on_window_exited"))
	$"Camera x".make_current()
	current_camera = $"Camera x"

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		if event.relative.x != 0:
			x = event.relative.x * mouse_sensitivity
		if event.relative.y != 0:
			y = event.relative.y * mouse_sensitivity
	
	if event is InputEventKey:
		if event.is_action_pressed("change_camera"):
			if camera_number == 0:
				current_camera = $"Camera2 X"
				#$"Camera2 X".make_current()
				camera_number = 1
			else:
				current_camera = $"Camera x"
				#$"Camera x".make_current()
				camera_number = 0

func _process(delta):
	if x != 0:
		if inverse_x:
			rotate_y(x*delta)
		else:
			rotate_y(-x*delta)
	if y != 0:
		if inverse_x:
			current_camera.rotate_x(y*delta)
		else:
			current_camera.rotate_x(-y*delta)
	
	#$"Camera x".rotation.x = clamp($"Camera x".rotation.x, -PI/2,PI/2)
	
	x = 0
	y = 0

func on_window_selected():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func on_window_exited():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

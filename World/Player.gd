extends CharacterBody3D

var camera_rotation

var w : bool = false
var a : bool = false
var s : bool = false
var d : bool = false

var walk_speed = 1
var sprint_speed = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _unhandled_input(event):
	if event is InputEventKey:
		if event.is_action_pressed("w"):
			w = true
		if event.is_action_released("w"):
			w = false
		if event.is_action_pressed("a"):
			a = true
		if event.is_action_released("a"):
			a = false
		if event.is_action_pressed("d"):
			d = true
		if event.is_action_released("d"):
			d = false
		if event.is_action_pressed("s"):
			s = true
		if event.is_action_released("s"):
			s = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	camera_rotation = $"Camera y".rotation.y
	rotation.y = camera_rotation
	print("rotation: ",rotation)
#	print("camera rotation: ", $"Camera y".rotation)

func _physics_process(delta):
	var speed = 10
	if w:
		print("hbasdbhsd")
		#if rotation.y > 0 and rotation.y < PI/2:
		var direction = Vector3(speed*cos(rotation.y),0.0,speed*sin(rotation.y))
		#apply_central_impulse(100*direction)

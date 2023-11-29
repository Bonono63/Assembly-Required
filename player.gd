extends RigidBody3D

const WALKING_SPEED = 4.317
const RUNNING_SPEED = 9
const JUMP_VELOCITY = 1

# speed in meters per second
var SPEED : float = WALKING_SPEED

var walking : bool = false
var walking_time : int = 0

@export var entities : Node3D

@export var mouse_sensitivity = 0.025

var x = 0
var y = 0

var inverse_x : bool = false
var inverse_y : bool = false

var current_camera : Camera3D
var w : bool
var a : bool
var s : bool
var d : bool
var sprint : bool
var shift : bool
var jump : bool

var gravity : Vector3

func _ready():
	get_window().focus_entered.connect(Callable(self,"on_window_selected"))
	get_window().focus_exited.connect(Callable(self,"on_window_exited"))
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body : Node):
	print(body)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		if event.relative.x != 0:
			x = event.relative.x
		if event.relative.y != 0:
			y = event.relative.y
	
	if event is InputEventKey:
		if event.is_action_pressed("w"):
			w = true
		if event.is_action_released("w"):
			w = false
		
		if event.is_action_pressed("a"):
			a = true
		if event.is_action_released("a"):
			a = false
		
		if event.is_action_pressed("s"):
			s = true
		if event.is_action_released("s"):
			s = false
		
		if event.is_action_pressed("d"):
			d = true
		if event.is_action_released("d"):
			d = false
		
		if event.is_action_pressed("sprint"):
			sprint = true
		if event.is_action_released("sprint"):
			sprint = false
		
		if event.is_action_pressed("shift"):
			shift = true
		if event.is_action_released("shift"):
			shift = false
		
		if event.is_action_pressed("jump"):
			jump = true
		if event.is_action_released("jump"):
			jump = false

# Implement step assistance, essentially jump the player up the distance to cover a specific height, important for slopes, walking up a slope of blocks, or walking over small collision boxes

func _process(delta):
	
	# Camera 
	if x != 0:
		if inverse_x:
			$"Camera_y".rotation_degrees.y += (x * mouse_sensitivity)
		else:
			$"Camera_y".rotation_degrees.y += (-x * mouse_sensitivity)
	if y != 0:
		if inverse_x:
			$"Camera_y/Camera_x".rotation_degrees.x += (y * mouse_sensitivity)
		else:
			$"Camera_y/Camera_x".rotation_degrees.x += (-y * mouse_sensitivity)
	
	# movment SPEED
	
	if sprint:
		SPEED = RUNNING_SPEED
	else:
		SPEED = WALKING_SPEED
	
	# TODO make all of these movements relative to the down vector/gravity
	#movement
	var direction : float = $"Camera_y".rotation.y
	
	var forward : Vector3 = Vector3(-sin(direction),0,-cos(direction)) * SPEED * delta
	var backward : Vector3 = Vector3(sin(direction),0,cos(direction)) * SPEED * delta
	var left : Vector3 = Vector3(-sin(direction+(PI/2)),0,-cos(direction+(PI/2))) * SPEED * delta
	var right : Vector3 = Vector3(-sin(direction-(PI/2)),0,-cos(direction-(PI/2))) * SPEED * delta
	var up : Vector3 = Vector3(0,3,0) * SPEED * delta * 0.5
	var down : Vector3 = Vector3(0,-3,0) * SPEED * delta * 0.5
	
	var velocity : Vector3 = Vector3.ZERO
	
	if w:
		velocity += forward
	if s:
		velocity += backward
	if a:
		velocity += left
	if d:
		velocity += right
	if jump:
		velocity += up
	if shift:
		velocity += down
	
	#position += velocity
	
	move_and_collide(velocity)
	
	x = 0
	y = 0

func on_window_selected():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func on_window_exited():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

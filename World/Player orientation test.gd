extends RigidBody3D

var _move_direction := Vector3.ZERO
var last_strong_direction := Vector3.FORWARD
var local_gravity = Vector3.DOWN

func _integrate_forces(state):
	if _move_direction.length() > 0.2:
		last_strong_direction = _move_direction.normalized()
	
	_move_direction = _get_model_oriented_input()
	
	local_gravity = state.total_gravity.normalized()
	_orient_character_to_direction(last_strong_direction, state.step)

func _orient_character_to_direction(direction : Vector3, delta : float) -> void:
	var left_axis : Vector3 = -local_gravity.cross(direction)
	var rotation_quat := Quaternion(Basis(left_axis, -local_gravity, direction).orthonormalized())
	var _transform := Quaternion(transform.basis.orthonormalized())
	
	var c = _transform.slerp(rotation_quat, delta * 8 )
	
	transform.basis = Basis(c)

func _get_model_oriented_input():
	return Vector3.ZERO

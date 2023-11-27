extends RigidBody3D

func _integrate_forces(state):
	
	look_at(global_position+(state.transform.basis.z).normalized(), -state.total_gravity.normalized(), true)

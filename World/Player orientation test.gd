extends RigidBody3D

@export var locked_entity : Node3D

func _process(_delta):
	transform.basis = Basis()
	var target_position = locked_entity.position
	var looking_transform = transform.looking_at(target_position, Vector3(0,1,0), true)
	print(looking_transform.basis)
	looking_transform.
	transform = looking_transform
	transform.orthonormalized()

extends MeshInstance3D

var mesh_data : ArrayMesh

signal recieve_mesh

func init(_mesh_data : ArrayMesh) -> void:
	mesh_data = _mesh_data
	emit_signal("recieve_mesh")

func _ready() -> void:
	# wait for mesh_data to be sents
	await recieve_mesh
	mesh = mesh_data

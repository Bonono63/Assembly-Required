extends MeshInstance3D

var mesh_data
var wireframe : bool = false

signal recieve_mesh

func init(_mesh_data : Array, _wireframe : bool) -> void:
	mesh_data = _mesh_data
	wireframe = _wireframe
	emit_signal("recieve_mesh")

func _ready() -> void:
	# load mesh data and add it to the mesh instance
	mesh = ArrayMesh.new()
	await recieve_mesh
	if wireframe:
		mesh.add_surface_from_arrays(Mesh.PRIMITIVE_LINES, mesh_data)
	else:
		mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, mesh_data)
	var mat = Material.new()
	mat.set("cull_mode", 0)
	mat.set("albedo_color",Color.GRAY)
	mesh.surface_set_material(0, mat)

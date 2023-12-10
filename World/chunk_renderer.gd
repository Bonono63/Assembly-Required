extends MeshInstance3D

const chunk_length_cubed = 32*32*32
const chunk_length_squared = 32*32
const chunk_length = 32
const mesh_offset = Vector3(0.5,0.5,0.5)

var chunk_data : Chunk
var size : int

signal recieve_mesh

func init(_chunk_data : Chunk, _size : int = 1) -> void:
	chunk_data = _chunk_data
	size = _size
	emit_signal("recieve_mesh")


func _ready() -> void:
	# wait for mesh_data to be sents
	$ChunkOutline.mesh.size = Vector3(size,size,size)
	$ChunkOutline.position = Vector3(size/2,size/2,size/2)

func update(_chunk_data : Chunk, _size : int = 1) -> void:
	
	chunk_data = _chunk_data
	size = _size
	
	$ChunkOutline.mesh.size = Vector3(size,size,size)
	$ChunkOutline.position = Vector3(size/2,size/2,size/2)


# Create chunk meshes
# Currenty does not have any greedy meshing
func generate_chunk_mesh(chunk : Chunk) -> ArrayMesh:
	var start_time = Time.get_ticks_msec()
	
	var final_mesh : ArrayMesh = ArrayMesh.new()
	for _block_state in chunk.palette.size():
		var mesh_data : Array = []
		
		mesh_data.resize(ArrayMesh.ARRAY_MAX)
		mesh_data[ArrayMesh.ARRAY_VERTEX] = PackedVector3Array()
		mesh_data[ArrayMesh.ARRAY_TEX_UV] = PackedVector2Array()
		mesh_data[ArrayMesh.ARRAY_COLOR] = PackedColorArray()
		
		for index in chunk_length_cubed:
			var index_data = chunk.get_block_state(index)
			if index_data.get_full():
				var pos : Vector3 = index_tools.index_to_pos(index)
				
				# up face
				var up = index_tools.get_above_pos(index)
				if up == -1 or !chunk.get_block_state(up).get_full():
					mesh_data[ArrayMesh.ARRAY_VERTEX].append(Vector3(0.5, 0.5, 0.5)+pos+mesh_offset)
					mesh_data[ArrayMesh.ARRAY_VERTEX].append(Vector3(-0.5, 0.5, 0.5)+pos+mesh_offset)
					mesh_data[ArrayMesh.ARRAY_VERTEX].append(Vector3(0.5, 0.5, -0.5)+pos+mesh_offset)
					
					mesh_data[ArrayMesh.ARRAY_VERTEX].append(Vector3(-0.5, 0.5, 0.5)+pos+mesh_offset)
					mesh_data[ArrayMesh.ARRAY_VERTEX].append(Vector3(-0.5, 0.5, -0.5)+pos+mesh_offset)
					mesh_data[ArrayMesh.ARRAY_VERTEX].append(Vector3(0.5, 0.5, -0.5)+pos+mesh_offset)
					
					mesh_data[ArrayMesh.ARRAY_TEX_UV].append(Vector2(1,1))
					mesh_data[ArrayMesh.ARRAY_TEX_UV].append(Vector2(0,1))
					mesh_data[ArrayMesh.ARRAY_TEX_UV].append(Vector2(1,0))
					
					mesh_data[ArrayMesh.ARRAY_TEX_UV].append(Vector2(0,1))
					mesh_data[ArrayMesh.ARRAY_TEX_UV].append(Vector2(0,0))
					mesh_data[ArrayMesh.ARRAY_TEX_UV].append(Vector2(1,0))
					
					mesh_data[ArrayMesh.ARRAY_COLOR].append(Color(1.0,1.0,1.0,0.35))
					mesh_data[ArrayMesh.ARRAY_COLOR].append(Color(1.0,1.0,1.0,0.35))
					mesh_data[ArrayMesh.ARRAY_COLOR].append(Color(1.0,1.0,1.0,0.35))
					mesh_data[ArrayMesh.ARRAY_COLOR].append(Color(0.0,0.0,0.0,0.0))
					mesh_data[ArrayMesh.ARRAY_COLOR].append(Color(0.0,0.0,0.0,0.0))
					mesh_data[ArrayMesh.ARRAY_COLOR].append(Color(0.0,0.0,0.0,0.0))
				
				# forward face
				var forward = index_tools.get_backward_pos(index)
				if forward == -1 or !chunk.get_block_state(forward).get_full():
					mesh_data[ArrayMesh.ARRAY_VERTEX].append(Vector3(-0.5, 0.5, -0.5)+pos+mesh_offset)
					mesh_data[ArrayMesh.ARRAY_VERTEX].append(Vector3(-0.5, 0.5, 0.5)+pos+mesh_offset)
					mesh_data[ArrayMesh.ARRAY_VERTEX].append(Vector3(-0.5, -0.5, -0.5)+pos+mesh_offset)
					mesh_data[ArrayMesh.ARRAY_VERTEX].append(Vector3(-0.5, 0.5, 0.5)+pos+mesh_offset)
					mesh_data[ArrayMesh.ARRAY_VERTEX].append(Vector3(-0.5, -0.5, 0.5)+pos+mesh_offset)
					mesh_data[ArrayMesh.ARRAY_VERTEX].append(Vector3(-0.5, -0.5, -0.5)+pos+mesh_offset)
					
					mesh_data[ArrayMesh.ARRAY_TEX_UV].append(Vector2(1,1))
					mesh_data[ArrayMesh.ARRAY_TEX_UV].append(Vector2(0,1))
					mesh_data[ArrayMesh.ARRAY_TEX_UV].append(Vector2(1,0))
					
					mesh_data[ArrayMesh.ARRAY_TEX_UV].append(Vector2(0,1))
					mesh_data[ArrayMesh.ARRAY_TEX_UV].append(Vector2(0,0))
					mesh_data[ArrayMesh.ARRAY_TEX_UV].append(Vector2(1,0))
					
					mesh_data[ArrayMesh.ARRAY_COLOR].append(Color(1.0,1.0,1.0,0.35))
					mesh_data[ArrayMesh.ARRAY_COLOR].append(Color(1.0,1.0,1.0,0.35))
					mesh_data[ArrayMesh.ARRAY_COLOR].append(Color(1.0,1.0,1.0,0.35))
					mesh_data[ArrayMesh.ARRAY_COLOR].append(Color(0.0,0.0,0.0,0.0))
					mesh_data[ArrayMesh.ARRAY_COLOR].append(Color(0.0,0.0,0.0,0.0))
					mesh_data[ArrayMesh.ARRAY_COLOR].append(Color(0.0,0.0,0.0,0.0))
					
				# right face
				var right = index_tools.get_right_pos(index)
				if right == -1 or !chunk.get_block_state(right).get_full():
					mesh_data[ArrayMesh.ARRAY_VERTEX].append(Vector3(-0.5, 0.5, 0.5)+pos+mesh_offset)
					mesh_data[ArrayMesh.ARRAY_VERTEX].append(Vector3(0.5, 0.5, 0.5)+pos+mesh_offset)
					mesh_data[ArrayMesh.ARRAY_VERTEX].append(Vector3(-0.5, -0.5, 0.5)+pos+mesh_offset)
					mesh_data[ArrayMesh.ARRAY_VERTEX].append(Vector3(0.5, 0.5, 0.5)+pos+mesh_offset)
					mesh_data[ArrayMesh.ARRAY_VERTEX].append(Vector3(0.5, -0.5, 0.5)+pos+mesh_offset)
					mesh_data[ArrayMesh.ARRAY_VERTEX].append(Vector3(-0.5, -0.5, 0.5)+pos+mesh_offset)
					
					mesh_data[ArrayMesh.ARRAY_TEX_UV].append(Vector2(1,1))
					mesh_data[ArrayMesh.ARRAY_TEX_UV].append(Vector2(0,1))
					mesh_data[ArrayMesh.ARRAY_TEX_UV].append(Vector2(1,0))
					
					mesh_data[ArrayMesh.ARRAY_TEX_UV].append(Vector2(0,1))
					mesh_data[ArrayMesh.ARRAY_TEX_UV].append(Vector2(0,0))
					mesh_data[ArrayMesh.ARRAY_TEX_UV].append(Vector2(1,0))
					
					mesh_data[ArrayMesh.ARRAY_COLOR].append(Color(1.0,1.0,1.0,0.35))
					mesh_data[ArrayMesh.ARRAY_COLOR].append(Color(1.0,1.0,1.0,0.35))
					mesh_data[ArrayMesh.ARRAY_COLOR].append(Color(1.0,1.0,1.0,0.35))
					mesh_data[ArrayMesh.ARRAY_COLOR].append(Color(0.0,0.0,0.0,0.0))
					mesh_data[ArrayMesh.ARRAY_COLOR].append(Color(0.0,0.0,0.0,0.0))
					mesh_data[ArrayMesh.ARRAY_COLOR].append(Color(0.0,0.0,0.0,0.0))
				
				# backward face
				var backward = index_tools.get_forward_pos(index)
				if backward == -1 or !chunk.get_block_state(backward).get_full():
					mesh_data[ArrayMesh.ARRAY_VERTEX].append(Vector3(0.5, 0.5, 0.5)+pos+mesh_offset)
					mesh_data[ArrayMesh.ARRAY_VERTEX].append(Vector3(0.5, 0.5, -0.5)+pos+mesh_offset)
					mesh_data[ArrayMesh.ARRAY_VERTEX].append(Vector3(0.5, -0.5, 0.5)+pos+mesh_offset)
					mesh_data[ArrayMesh.ARRAY_VERTEX].append(Vector3(0.5, 0.5, -0.5)+pos+mesh_offset)
					mesh_data[ArrayMesh.ARRAY_VERTEX].append(Vector3(0.5, -0.5, -0.5)+pos+mesh_offset)
					mesh_data[ArrayMesh.ARRAY_VERTEX].append(Vector3(0.5, -0.5, 0.5)+pos+mesh_offset)
					
					mesh_data[ArrayMesh.ARRAY_TEX_UV].append(Vector2(1,1))
					mesh_data[ArrayMesh.ARRAY_TEX_UV].append(Vector2(0,1))
					mesh_data[ArrayMesh.ARRAY_TEX_UV].append(Vector2(1,0))
					
					mesh_data[ArrayMesh.ARRAY_TEX_UV].append(Vector2(0,1))
					mesh_data[ArrayMesh.ARRAY_TEX_UV].append(Vector2(0,0))
					mesh_data[ArrayMesh.ARRAY_TEX_UV].append(Vector2(1,0))
					
					mesh_data[ArrayMesh.ARRAY_COLOR].append(Color(1.0,1.0,1.0,0.35))
					mesh_data[ArrayMesh.ARRAY_COLOR].append(Color(1.0,1.0,1.0,0.35))
					mesh_data[ArrayMesh.ARRAY_COLOR].append(Color(1.0,1.0,1.0,0.35))
					mesh_data[ArrayMesh.ARRAY_COLOR].append(Color(0.0,0.0,0.0,0.0))
					mesh_data[ArrayMesh.ARRAY_COLOR].append(Color(0.0,0.0,0.0,0.0))
					mesh_data[ArrayMesh.ARRAY_COLOR].append(Color(0.0,0.0,0.0,0.0))
				
				# left face
				var left = index_tools.get_left_pos(index)
				if left == -1 or !chunk.get_block_state(left).get_full():
					mesh_data[ArrayMesh.ARRAY_VERTEX].append(Vector3(0.5, 0.5, -0.5)+pos+mesh_offset)
					mesh_data[ArrayMesh.ARRAY_VERTEX].append(Vector3(-0.5, 0.5, -0.5)+pos+mesh_offset)
					mesh_data[ArrayMesh.ARRAY_VERTEX].append(Vector3(0.5, -0.5, -0.5)+pos+mesh_offset)
					mesh_data[ArrayMesh.ARRAY_VERTEX].append(Vector3(-0.5, 0.5, -0.5)+pos+mesh_offset)
					mesh_data[ArrayMesh.ARRAY_VERTEX].append(Vector3(-0.5, -0.5, -0.5)+pos+mesh_offset)
					mesh_data[ArrayMesh.ARRAY_VERTEX].append(Vector3(0.5, -0.5, -0.5)+pos+mesh_offset)
					
					mesh_data[ArrayMesh.ARRAY_TEX_UV].append(Vector2(1,1))
					mesh_data[ArrayMesh.ARRAY_TEX_UV].append(Vector2(0,1))
					mesh_data[ArrayMesh.ARRAY_TEX_UV].append(Vector2(1,0))
					
					mesh_data[ArrayMesh.ARRAY_TEX_UV].append(Vector2(0,1))
					mesh_data[ArrayMesh.ARRAY_TEX_UV].append(Vector2(0,0))
					mesh_data[ArrayMesh.ARRAY_TEX_UV].append(Vector2(1,0))
					
					mesh_data[ArrayMesh.ARRAY_COLOR].append(Color(1.0,1.0,1.0,0.35))
					mesh_data[ArrayMesh.ARRAY_COLOR].append(Color(1.0,1.0,1.0,0.35))
					mesh_data[ArrayMesh.ARRAY_COLOR].append(Color(1.0,1.0,1.0,0.35))
					mesh_data[ArrayMesh.ARRAY_COLOR].append(Color(0.0,0.0,0.0,0.0))
					mesh_data[ArrayMesh.ARRAY_COLOR].append(Color(0.0,0.0,0.0,0.0))
					mesh_data[ArrayMesh.ARRAY_COLOR].append(Color(0.0,0.0,0.0,0.0))
					
				# down face
				var down = index_tools.get_below_pos(index)
				if down == -1 or !chunk.get_block_state(down).get_full():
					mesh_data[ArrayMesh.ARRAY_VERTEX].append(Vector3(-0.5, -0.5, 0.5)+pos+mesh_offset)
					mesh_data[ArrayMesh.ARRAY_VERTEX].append(Vector3(0.5, -0.5, 0.5)+pos+mesh_offset)
					mesh_data[ArrayMesh.ARRAY_VERTEX].append(Vector3(-0.5, -0.5, -0.5)+pos+mesh_offset)
					mesh_data[ArrayMesh.ARRAY_VERTEX].append(Vector3(0.5, -0.5, 0.5)+pos+mesh_offset)
					mesh_data[ArrayMesh.ARRAY_VERTEX].append(Vector3(0.5, -0.5, -0.5)+pos+mesh_offset)
					mesh_data[ArrayMesh.ARRAY_VERTEX].append(Vector3(-0.5, -0.5, -0.5)+pos+mesh_offset)
					
					mesh_data[ArrayMesh.ARRAY_TEX_UV].append(Vector2(1,1))
					mesh_data[ArrayMesh.ARRAY_TEX_UV].append(Vector2(0,1))
					mesh_data[ArrayMesh.ARRAY_TEX_UV].append(Vector2(1,0))
					
					mesh_data[ArrayMesh.ARRAY_TEX_UV].append(Vector2(0,1))
					mesh_data[ArrayMesh.ARRAY_TEX_UV].append(Vector2(0,0))
					mesh_data[ArrayMesh.ARRAY_TEX_UV].append(Vector2(1,0))
					
					mesh_data[ArrayMesh.ARRAY_COLOR].append(Color(1.0,1.0,1.0,0.35))
					mesh_data[ArrayMesh.ARRAY_COLOR].append(Color(1.0,1.0,1.0,0.35))
					mesh_data[ArrayMesh.ARRAY_COLOR].append(Color(1.0,1.0,1.0,0.35))
					mesh_data[ArrayMesh.ARRAY_COLOR].append(Color(0.0,0.0,0.0,0.0))
					mesh_data[ArrayMesh.ARRAY_COLOR].append(Color(0.0,0.0,0.0,0.0))
					mesh_data[ArrayMesh.ARRAY_COLOR].append(Color(0.0,0.0,0.0,0.0))
		
		final_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, mesh_data)
		
		# set the surface index material to the block's material
		final_mesh.surface_set_material(_block_state, chunk.palette[_block_state].get_material())
		
	#print(final_mesh)
	print("Elapsed time for mesh generation: ",Time.get_ticks_msec()-start_time, " milliseconds")
	return final_mesh

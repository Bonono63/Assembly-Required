extends RigidBody3D

# number of blocks in a given chunk
const chunk_length = 32
const chunk_length_squared = 32*32
const chunk_length_cubed = 32*32*32

const mesh_offset = Vector3(0.5,0.5,0.5)

var entity_size : Vector3i = Vector3i.ZERO
var seed : int

# chunks stored in the entity
var chunks : Dictionary = {}

@onready var world = get_parent().get_parent()

@export var player : Node3D

signal load_chunks


# TODO add player as a var when the solar system generates in the future
func _init():
	
	connect("load_chunks", Callable(self, "on_load_chunks"))
	
	print("generating chunks in memory, SUPER EFFICIENT!")
	
	var size = 1
	for index in size**3:
		var pos = index_tools.index_to_pos(index)
		print(pos)
		var start_time = Time.get_ticks_msec()
		chunks[pos] = _Chunk.new([], Chunk_Data.new())
		var end_time = Time.get_ticks_msec()
		print("Elapsed time for chunk ", pos,": ", end_time-start_time, " milliseconds")

func _ready():
	world.connect("reload_chunks", Callable(self, "on_reload_chunks"))
	
	emit_signal("load_chunks", chunks)
	#generate_chunks(get_chunks_within_render_distance())
	#generate_convex_collision_shapes(chunks)
	#print(get_shape_owners().size())


func _physics_process(delta):
	#position.x = 5*sin(Time.get_ticks_msec()*0.02)#*delta
	#print(sin(Time.get_ticks_msec()*0.2))
	#print(Time.get_ticks_msec()*0.2)
	#move_and_collide(Vector3(2*sin(Time.get_ticks_msec()*0.002),0,0))
	#print(position)
	pass

func on_load_chunks(_chunks : Dictionary):
	print("loading chunks")
	generate_chunks(_chunks)


func pos_to_chunk_pos(pos : Vector3) -> Vector3i:
	return Vector3i(pos/32)


func get_chunks_coordinates_within_render_distance() -> Array[Vector3i]:
	var chunk_pos : Vector3i = pos_to_chunk_pos(player.position)
	var radius : int = Settings.render_radius
	var points : Array[Vector3i] = []
	
	# chunk sphere equation (x)^2 + (y)^2 + (z)^2 = r^2
	
	# break down the z coordinate to turn it into a 2 dimensional problem
	# so if the render radius is 4 we have 8 z layers to compute
	for z in range(-radius, radius):
		for y in range(-radius, radius):
			for x in range(-radius, radius):
				# if the point is within the circle equation then add it to the chunk radius
				if (x**2)+(y**2)+(z**2)<=(radius**2):
					points.append(Vector3i(x,y,z)+chunk_pos)
	
	return points


func get_player_chunk(player : Node3D) -> _Chunk:
	var pos = pos_to_chunk_pos(player.position)
	
	# TODO ADD CHUNKS TO MEMORY or something
	return null
	


func on_reload_chunks():
	clear_chunk_renderers()
	# TODO mesh generation code 2.0 + collision shapes?
	#generate_chunks(get_chunks_within_render_distance())


func clear_chunk_renderers() -> void:
	for renderer in $Renderer.get_children():
		renderer.queue_free()


# create and load chunk renderers
func generate_chunks(_chunks : Dictionary) -> void:
	
	for chunk in _chunks.keys():
		var before_time = Time.get_ticks_msec()
		
		#if !_chunks[chunk].is_empty():
		var mesh = generate_chunk_mesh(_chunks.get(chunk))
		var renderer = preload("res://World/chunk_renderer.tscn").instantiate()
		renderer.position = chunk*32
		$Renderer.add_child(renderer)
		renderer.init(mesh, false)
		renderer.name = str(chunk)
		
		var after_time = Time.get_ticks_msec()
		print("Elapsed time for mesh generation: ",str((after_time-before_time)), " milliseconds")


# Creates the mesh to be rendered
# Currenty does not have any greedy meshing
func generate_chunk_mesh(chunk : _Chunk) -> Array:
	var vertex_data : Array[Vector3] = []
	
	# for each sequence
	for index in chunk_length_cubed:
		var index_data = chunk.get_block_state(index)
		if index_data.get_full():
			var pos : Vector3 = index_tools.index_to_pos(index)
			
			# up face
			var up = index_tools.get_above_pos(index)
			if up == -1 or !chunk.get_block_state(up).get_full():
				vertex_data.append(Vector3(0.5, 0.5, 0.5)+pos+mesh_offset)
				vertex_data.append(Vector3(-0.5, 0.5, 0.5)+pos+mesh_offset)
				vertex_data.append(Vector3(0.5, 0.5, -0.5)+pos+mesh_offset)
				vertex_data.append(Vector3(-0.5, 0.5, 0.5)+pos+mesh_offset)
				vertex_data.append(Vector3(-0.5, 0.5, -0.5)+pos+mesh_offset)
				vertex_data.append(Vector3(0.5, 0.5, -0.5)+pos+mesh_offset)
			
			# forward face
			var forward = index_tools.get_backward_pos(index)
			if forward == -1 or !chunk.get_block_state(forward).get_full():
				vertex_data.append(Vector3(-0.5, 0.5, -0.5)+pos+mesh_offset)
				vertex_data.append(Vector3(-0.5, 0.5, 0.5)+pos+mesh_offset)
				vertex_data.append(Vector3(-0.5, -0.5, -0.5)+pos+mesh_offset)
				vertex_data.append(Vector3(-0.5, 0.5, 0.5)+pos+mesh_offset)
				vertex_data.append(Vector3(-0.5, -0.5, 0.5)+pos+mesh_offset)
				vertex_data.append(Vector3(-0.5, -0.5, -0.5)+pos+mesh_offset)
			
			# right face
			var right = index_tools.get_right_pos(index)
			if right == -1 or !chunk.get_block_state(right).get_full():
				vertex_data.append(Vector3(-0.5, 0.5, 0.5)+pos+mesh_offset)
				vertex_data.append(Vector3(0.5, 0.5, 0.5)+pos+mesh_offset)
				vertex_data.append(Vector3(-0.5, -0.5, 0.5)+pos+mesh_offset)
				vertex_data.append(Vector3(0.5, 0.5, 0.5)+pos+mesh_offset)
				vertex_data.append(Vector3(0.5, -0.5, 0.5)+pos+mesh_offset)
				vertex_data.append(Vector3(-0.5, -0.5, 0.5)+pos+mesh_offset)
			
			# backward face
			var backward = index_tools.get_forward_pos(index)
			if backward == -1 or !chunk.get_block_state(backward).get_full():
				vertex_data.append(Vector3(0.5, 0.5, 0.5)+pos+mesh_offset)
				vertex_data.append(Vector3(0.5, 0.5, -0.5)+pos+mesh_offset)
				vertex_data.append(Vector3(0.5, -0.5, 0.5)+pos+mesh_offset)
				vertex_data.append(Vector3(0.5, 0.5, -0.5)+pos+mesh_offset)
				vertex_data.append(Vector3(0.5, -0.5, -0.5)+pos+mesh_offset)
				vertex_data.append(Vector3(0.5, -0.5, 0.5)+pos+mesh_offset)
			
			# left face
			var left = index_tools.get_left_pos(index)
			if left == -1 or !chunk.get_block_state(left).get_full():
				vertex_data.append(Vector3(0.5, 0.5, -0.5)+pos+mesh_offset)
				vertex_data.append(Vector3(-0.5, 0.5, -0.5)+pos+mesh_offset)
				vertex_data.append(Vector3(0.5, -0.5, -0.5)+pos+mesh_offset)
				vertex_data.append(Vector3(-0.5, 0.5, -0.5)+pos+mesh_offset)
				vertex_data.append(Vector3(-0.5, -0.5, -0.5)+pos+mesh_offset)
				vertex_data.append(Vector3(0.5, -0.5, -0.5)+pos+mesh_offset)
			
			# down face
			var down = index_tools.get_below_pos(index)
			if down == -1 or !chunk.get_block_state(down).get_full():
				vertex_data.append(Vector3(-0.5, -0.5, 0.5)+pos+mesh_offset)
				vertex_data.append(Vector3(0.5, -0.5, 0.5)+pos+mesh_offset)
				vertex_data.append(Vector3(-0.5, -0.5, -0.5)+pos+mesh_offset)
				vertex_data.append(Vector3(0.5, -0.5, 0.5)+pos+mesh_offset)
				vertex_data.append(Vector3(0.5, -0.5, -0.5)+pos+mesh_offset)
				vertex_data.append(Vector3(-0.5, -0.5, -0.5)+pos+mesh_offset)
	
	var mesh_data : Array
	mesh_data.resize(ArrayMesh.ARRAY_MAX)
	# we only add vertex data because computing indices is too much of a pain in the butt
	mesh_data[ArrayMesh.ARRAY_VERTEX] = PackedVector3Array(vertex_data)
	
	return mesh_data


func generate_convex_collision_shapes(_chunks : Array) -> void:
	clear_shape_owners()
	
	for chunk in _chunks:
		for i in chunk_length_cubed:
			var _block_state : block_state = chunk.chunk_data[i]
			# check if the block is air
			if _block_state.identifier != 0:
				var points : Array = []
				# iterate through every vertex in the block's model
				for vertex in GlobalResourceLoader.block_registry[_block_state.identifier].collision_shape:
					#offset the vertex by the block's position
					points.append(Vector3((chunk.position*32))+vertex+index_tools.index_to_pos(i))
					
				var collision_shape = ConvexPolygonShape3D.new()
				collision_shape.points = PackedVector3Array(points)
				
				var id = create_shape_owner(self)
				shape_owner_add_shape(id, collision_shape)


func clear_shape_owners() -> void:
	for _owner in get_shape_owners():
		remove_shape_owner(_owner)

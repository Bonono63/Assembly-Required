extends RigidBody3D

# number of blocks in a given chunk
const chunk_length = 32
const chunk_length_squared = 32*32
const chunk_length_cubed = 32*32*32

var entity_size : Vector3i = Vector3i.ZERO
var seed : int

# chunks stored in the entity
var chunks : Dictionary = {}

@onready var world = get_parent().get_parent()

@export var player : Node3D
 
# TODO add player as a var when the solar system generates in the future
func _init():
	print("generating chunks in memory, SUPER EFFICIENT!")
	var size = 3
	for x in size:
		for y in size:
			for z in size:
				print(Vector3(x,y,z))
				var generator = WorldGeneration.new(seed, Vector3i(x,y,z))
				await generator.chunk_data_loaded
				chunks[Vector3i(x,y,z)] = generator.get_chunk_data()
				#chunks[Vector3i(x,y,z)].set_block_state(chunk_size, block_state.new(0))
	
	print("generating chunk meshes")
	generate_chunks(chunks)

func _ready():
	world.connect("reload_chunks", Callable(self, "on_reload_chunks"))
	
	#generate_chunks(get_chunks_within_render_distance())
	#generate_convex_collision_shapes(chunks)
	#print(get_shape_owners().size())

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

func get_player_chunk(player : Node3D) -> Chunk:
	var pos = pos_to_chunk_pos(player.position)
	
	## TODO ADD CHUNKS TO MEMORY or something
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
	var before_time = Time.get_ticks_msec()
	for chunk in _chunks.keys():
		var mesh = generate_chunk_mesh(_chunks.get(chunk))
		if !mesh.is_empty():
			var renderer = preload("res://chunk_renderer.tscn").instantiate()
			renderer.position = chunk*32
			$Renderer.add_child(renderer)
			renderer.init(mesh, true)
			renderer.name = str(chunk)
	
	var after_time = Time.get_ticks_msec()
	print("Elapsed time for mesh generation: ",str((after_time-before_time)), " seconds")

# Creates the mesh to be rendered
# Currenty does not have culling or greedy meshing
func generate_chunk_mesh(chunk : Chunk) -> Array:
	if chunk.is_empty():
		return []
	else:
		# Create the mesh data
		var vertex_data : Array[Vector3] = []
		
		var i : int = 0
		while i < chunk_length_cubed:
			#get block data
			var _block_state : block_state = chunk.get_block_state(i)
			# check if the block is air
				# iterate through every vertex in the block's model
			if _block_state.identifier != 0:
				for vertex in GlobalResourceLoader.block_registry[_block_state.identifier].model:
					#offset the vertex by the block's position
					vertex_data.append(vertex+index_to_pos(i))
			
			#next index
			i+=1
		
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
					points.append(Vector3((chunk.position*32))+vertex+index_to_pos(i))
					
				var collision_shape = ConvexPolygonShape3D.new()
				collision_shape.points = PackedVector3Array(points)
				
				var id = create_shape_owner(self)
				shape_owner_add_shape(id, collision_shape)

func clear_shape_owners() -> void:
	for _owner in get_shape_owners():
		remove_shape_owner(_owner)

static func init_3d_array(array:Array, size : Vector3i):
	array.resize(size.x)
	for x in array.size():
		array[x] = []
		array[x].resize(size.y)
		for y in array[x].size():
			array[x][y] = []
			array[x][y].resize(size.z)

func index_to_pos(i : int) -> Vector3:
	return Vector3(i/(32*32),(i/32) % 32,i % 32)

func pos_to_index(pos : Vector3) -> int:
	return (pos.x*32*32)+(pos.y*32)+pos.z

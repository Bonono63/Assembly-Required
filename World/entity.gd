extends RigidBody3D

# number of blocks in a given chunk
const chunk_size = 32*32*32
# maximum number of chunks in any given axis
const entity_size = 32*32*32

# chunks stored in the entity
var chunks : Dictionary = {}

@onready var world = get_parent().get_parent()

@export var player : Node3D
 
# TODO add player as a var when the solar system generates in the future
func _init():
	pass

func _ready():
	world.connect("reload_chunks", Callable(self, "on_reload_chunks"))
	
	generate_chunks(get_chunks_within_render_distance())
	#generate_convex_collision_shapes(chunks)
	#print(get_shape_owners().size())

# create filler chunks
static func noise_data() -> Array[efficient_block_state]:
	var data : Array[efficient_block_state]
	#for block in chunk_size:
	#	data.append(block_state.new(0))
	#data[0] = block_state.new(1)
	#data[-1] = block_state.new(1)
	return data

func pos_to_chunk_pos(pos : Vector3) -> Vector3i:
	return Vector3i(pos/32)

func get_chunks_within_render_distance() -> Array[Chunk]:
	var chunk_pos : Vector3i = pos_to_chunk_pos(player.position)
	var _chunks : Array[Chunk] = []
	var radius : int = Settings.render_radius
	var points : Array[Vector3i] = []
	#implement some culling of hidden chunks
	
	# chunk sphere equation (x)^2 + (y)^2 + (z)^2 = r^2
	
	# break down the z coordinate to turn it into a 2 dimensional problem
	# so if the render radius is 4 we have 8 z layers to compute
	for z in range(-radius, radius):
		for y in range(-radius, radius):
			for x in range(-radius, radius):
				# if the point is within the circle equation then add it to the chunk radius
				if (x**2)+(y**2)+(z**2)<=(radius**2):
					points.append(Vector3i(x,y,z)+chunk_pos)
	
	for point in points:
		if point.x >= 0 and point.y >= 0 and point.z >= 0:
			print(point)
			var chunk = chunks[point]
			if chunk:
				_chunks.append(chunk)
	
	return _chunks

func on_reload_chunks():
	clear_chunks()
	generate_chunks(get_chunks_within_render_distance())

func clear_chunks() -> void:
	for renderer in $Renderer.get_children():
		renderer.queue_free()

# create and load chunk renderers
func generate_chunks(_chunks : Array ) -> void:
	
	for chunk in _chunks:
		var renderer = preload("res://chunk_renderer.tscn").instantiate()
		renderer.position = chunk.position*32
		$Renderer.add_child(renderer)
		var mesh = generate_chunk_mesh(chunk)
		renderer.init(mesh)
		renderer.name = str(chunk.position.x," ",chunk.position.y," ",chunk.position.z)

func generate_chunk_mesh(chunk : Chunk) -> Array:
	# Create the mesh data
	var vertex_data : Array[Vector3] = []
	
	var i : int = 0
	while i < chunk_size:
		#get block data
		var _block_state : block_state = chunk.chunk_data[i]
		# check if the block is air
		if _block_state.identifier != 0:
			# iterate through every vertex in the block's model
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
		for i in chunk_size:
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

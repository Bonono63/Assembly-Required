# Entity
extends RigidBody3D

# number of blocks in a given chunk
const chunk_length = 32
const chunk_length_squared = 32*32
const chunk_length_cubed = 32*32*32

var entity_size : Vector3i = Vector3i.ZERO
var seed : int
var generation : TerrainGeneration

# store direct chunk data
var chunks : Dictionary = {}
# list of chunks that need to be updated
var load_queue : Array[Vector3i] = []
var update_queue : Array[Vector3i] = []
var removal_queue : Array[Vector3i] = []

var generation_thread : Thread = Thread.new()

var chunk_mesh_buffer : Dictionary = {}

@onready var world = get_parent().get_parent()

@export var player : Node3D

signal load_chunks


# TODO add player as a var when the solar system generates in the future
func _init():
	generation = TerrainGeneration.new(seed)


var mesh_threads : Array[Thread]
var prev_pos : Vector3i = Vector3i(-1,-1,-1)
func _process(_delta):
	
	var pos = Vector3i(player.position/32)
	
	# add threading
	if !load_queue.is_empty():
		generation_thread.start(chunk_load_thread.bind())
	
	# add threading
	if !update_queue.is_empty():
		#allocate_chunk_renderers()
		pass
	
	for thread in mesh_threads:
		thread.wait_to_finish()
	
	if !removal_queue.is_empty():
		chunk_removal_thread()
	
	# chunk update whenever the current player chunk changes
	if pos != prev_pos:
		# request an update of all chunks that shouldn't remain in memory or need to be decreased in LOD
		# add update/loaded chunks into load and update queues
		var required_chunks : Array = get_chunks_coordinates_within_render_distance(player.position)
		
		for chunk in required_chunks:
			if chunk not in chunks:
				load_queue.append(chunk)
		
		for chunk in chunks:
			if chunk not in required_chunks:
				removal_queue.append(chunk)
		
		print("chunk update")
	
	prev_pos = pos


# either retrieve a chunk from a save or generate it using noise and add it to memory
func chunk_load_thread():
	for chunk in load_queue:
		
		# make a check for whether the chunk exists on the disk before generating the chunk data
		
		var start_time = Time.get_ticks_msec()
		
		# generating new chunk data
		generation.change_position(chunk)
		await generation.chunk_data_loaded
		chunks[chunk] = generation.get_chunk()
		
		update_queue.append(chunk)
		
		print("Elapsed time for chunk ", chunk,": ", Time.get_ticks_msec()-start_time, " milliseconds")
	
	load_queue.clear()
	generation_thread.wait_to_finish()


func allocate_chunk_renderers():
	for chunk in update_queue:
		var old_renderer = get_node("Renderer/"+str(chunk))
		if old_renderer == null:
			var renderer = preload("res://World/chunk_renderer.tscn").instantiate()
			renderer.position = chunk*32
			renderer.name = str(chunk)
			renderer.init()
			$Renderer.add_child(renderer)
	
	print($Renderer.get_children())


func clear_chunk_renderers() -> void:
	for renderer in $Renderer.get_children():
		renderer.queue_free()


# Remove chunks beyond the scope
func chunk_removal_thread():
	for chunk in removal_queue:
		chunks.erase(chunk)
		print("Erased chunk: ", chunk)
		var renderer = get_node("Renderer/"+str(chunk))
		if renderer != null:
			renderer.queue_free()
	
	removal_queue.clear()


func get_chunks_coordinates_within_render_distance(player_chunk_pos : Vector3) -> Array[Vector3i]:
	var radius : int = Settings.render_radius
	var points : Array[Vector3i] = []
	
	# chunk sphere equation (x)^2 + (y)^2 + (z)^2 = r^2
	
	# break down the z coordinate to turn it into a 2 dimensional problem
	# so if the render radius is 4 we have 8 z layers to compute
	for z in range(-radius, radius):
		for y in range(-radius, radius):
			for x in range(-radius, radius):
				# if the point is within the circle equation then add it to the chunk radius
				#if (x**2)+(y**2)+(z**2)<=(radius**2):
				var point : Vector3i = Vector3i(x,y,z)+Vector3i(player_chunk_pos/32)
				if point.x >= 0 and point.y >= 0 and point.z >= 0:
					points.append(point)
	
	return points

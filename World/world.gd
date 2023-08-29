extends Node3D

var registered_blocks : Array = []
var registered_items : Array = []

func register_block():
	pass

func register_item():
	pass

func _physics_process(delta):
	#entity gravity pass
	var children = $entities.get_children()
	#children.append($Player)
	for child in children:
		
		var center_pos = child.position
		var pull = 1 #child.weight
		
		for sibling in children:
			var sibling_pos : Vector3
			var distance : float
			var direction : Vector3
			
			if sibling != child:
				sibling_pos = sibling.position
				
				distance = center_pos.distance_to(sibling_pos)
				direction = sibling_pos.direction_to(center_pos)
				
				sibling.apply_central_impulse(pull*direction*(distance/10000))
				

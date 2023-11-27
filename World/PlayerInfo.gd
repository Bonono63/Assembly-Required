extends Label

@export var PlayerNode : Node3D

func _process(_delta):
	text = str("position: ",PlayerNode.position,"\nChunk position: ",PlayerNode.position/32)

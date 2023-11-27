class_name Block
extends Node

# block number which correlates to the enum
var identifier : int
# for glass and other transparent blocks
var translucent : bool
# for blocks that aren't full blocks
var is_full : bool
# Display Name
var display_name : String
# the model the block has 
var model : Array = []
# the collision shape of the block
var collision_shape : Array = []

func _init(_identifier : bool, _translucent : bool, _is_full : bool, _display_name : String, _model : Array, _collision_shape : Array):
	identifier = _identifier
	translucent = _translucent
	is_full = _is_full
	display_name = _display_name
	model = _model
	collision_shape = _collision_shape

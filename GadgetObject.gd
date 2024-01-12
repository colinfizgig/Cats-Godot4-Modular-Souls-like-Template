extends Area3D
class_name GadgetObject

## Uses layer 3 for detecting hitable targets.

@export var gadget_info : GadgetResource

func _ready():
	set_collision_mask_value(3,true)
	set_collision_layer_value(1,false)
	monitoring = false

func activate():
	# turn on object col shape to detect collisions
	monitoring = true
	print("Object active")
	
func deactivate():
	monitoring = false
	print("Object inactive")
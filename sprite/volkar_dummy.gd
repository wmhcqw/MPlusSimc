extends Dummy

class_name VolkarDummy


var boss_node: Volkar

func _enter_tree():
	speed = 100
	super._enter_tree()
	rotations = [0, 1, 2, 3]
	rotate_intervals = [5, 10, 10, 10]
	
	for node in get_parent().get_children():
		if is_instance_of(node, Volkar):
			boss_node = node
	rotate_timer.start(20)
	current_target = global_position
	

func _process(delta):
	if boss_node.is_active:
		rotations = [1, 2, 3]

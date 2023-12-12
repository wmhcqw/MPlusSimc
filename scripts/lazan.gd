extends Node2D



func _process(delta):
	for node in get_children():
		if is_instance_of(node, Player):
			if node.health <= 0:
				get_tree().change_scene_to_file("res://select.tscn")

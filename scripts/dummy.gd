extends CharacterBody2D

class_name Dummy


var speed = 50
var health = 100
var current_target
var target_positions = []
var rotations = []
var rotate_intervals = []
var current_rotations = 0
var path_finder = NavigationAgent2D.new()

var rotate_timer = Timer.new()



func _enter_tree():
	rotate_timer.autostart = false
	rotate_timer.one_shot = true
	rotate_timer.timeout.connect(_run_rotations)
	add_child(rotate_timer)
	
	path_finder.avoidance_enabled = true
	path_finder.radius = 18
	path_finder.debug_enabled = true
	add_child(path_finder)
	
	
func get_movement_vector():
	var dir = Vector2.ZERO
	var distance = sqrt((global_position.x - current_target.x) ** 2 + (global_position.y - current_target.y) ** 2)
	if distance <= 10:
		return dir
	else:
		dir = to_local(path_finder.get_next_path_position())
	return dir
	
	
func _physics_process(_delta):
	path_finder.target_position = current_target
	var movement_vector = get_movement_vector()
	var direction = movement_vector.normalized()
	velocity = direction * speed
	move_and_slide()
	
	
func _run_rotations():
	rotate_timer.start(rotate_intervals[current_rotations])
	current_rotations += 1
	if current_rotations >= len(rotations):
		current_rotations = 0
	current_target = target_positions[current_rotations]

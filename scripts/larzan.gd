extends Monster

class_name Larzan

var is_chasing = false

var chase_channeling_timer = Timer.new()
var chase_timer = Timer.new()
var scare_timer = Timer.new()

var scare_ray = RayCast2D.new()

func _enter_tree():
	super._enter_tree()
	spell_list = ["bite", "scare", "chase"]
	cast_intervals = [10, 10, 5, 15]  # [10, 10, 5, 15]
	rotations = [0, 1, 0, 2]
	
	chase_channeling_timer.autostart = false
	chase_channeling_timer.one_shot = true
	chase_channeling_timer.timeout.connect(_on_chase_start)
	add_child(chase_channeling_timer)
	
	chase_timer.autostart = false
	chase_timer.one_shot = true
	chase_timer.timeout.connect(_on_chase_end)
	add_child(chase_timer)
	
	scare_timer.autostart = false
	scare_timer.one_shot = true
	scare_timer.timeout.connect(_on_scare_cast)
	add_child(scare_timer)
	
	scare_ray.collision_mask = 2 # searching for players
	scare_ray.hit_from_inside = false
	scare_ray.enabled = false
	add_child(scare_ray)
	
func _on_chase_start():
	is_channeling = false
	is_casting = true
	is_chasing = true
	chase_timer.start(7)
	
func _on_chase_end():
	is_channeling = false
	is_casting = false
	is_chasing = false
	
func _on_scare_cast():
	is_channeling = false
	is_casting = false
	for node in get_parent().get_children():
		if is_instance_of(node, Player):
			scare_ray.target_position = node.position - position
			scare_ray.enabled = true
			scare_ray.force_raycast_update()
			print(scare_ray.get_collider())
			if scare_ray.get_collider() == node:
				print("Found Player!")
				node.health = -1
	scare_ray.enabled = false
	

func _process(_delta):
	super._process(_delta)
	
	# if not casting or channeling, reset current select to tank
	if not is_chasing and not is_channeling:
		for node in get_parent().get_children():
			if is_instance_of(node, Player):
				if node.role == "healer":
					current_select = node
	if is_chasing:
		speed = 15
		var distance = sqrt((position.x-current_select.position.x)**2 + (position.y-current_select.position.y)**2)
		if distance <= 50:
			current_select.health = -1
	else:
		speed = 50
	
func bite():
	for node in get_parent().get_children():
		if is_instance_of(node, Player):
			if node.role == "tank":
				node.harmful = 1
				break
	print("Bite Tank")
	
func scare():
	is_channeling = true
	scare_timer.start(5)
	print("Start Scare")

func chase():
	for node in get_parent().get_children():
		if is_instance_of(node, Player):
			if node.is_player_control:
				self.current_select = node
				is_channeling = true
				is_chasing = false
				is_casting = false
				chase_channeling_timer.start(3)
	print("Chase One")


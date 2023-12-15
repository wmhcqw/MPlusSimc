extends Boss

class_name Volkar

const VolkarJump = preload("res://sprite/volkar_jump.tscn")

var is_active = false
var active_timer = Timer.new()
var spit_timer = Timer.new()
var spread_timer = Timer.new()

var player_node: Player
var dummy_node: Dummy
var jump_dummies = []


func _enter_tree():
	super._enter_tree()
	is_boss = true
	spell_list = ["jump", "spread"]
	
	cast_times = [0.01, 3]
	channel_times = [3, 0.01]
	
	prompts = ["沃卡尔正在使用剧毒跳跃，躲开脚下圈！", "沃卡尔正在散播毒液，奶妈注意加血！"]
	cast_intervals = [5, 5]
	rotations = [0, 1]
	
	active_timer.autostart = false
	active_timer.one_shot = true
	active_timer.timeout.connect(_on_active)
	add_child(active_timer)
	
	spit_timer.autostart = false
	spit_timer.one_shot = false
	spit_timer.timeout.connect(spit)
	add_child(spit_timer)
	
	spread_timer.autostart = false
	spread_timer.one_shot = true
	spread_timer.timeout.connect(_on_spread_end)
	add_child(spread_timer)
	
func _process(delta):
	super._process(delta)
	
	if not player_node:
		for node in get_parent().get_children():
			if is_instance_of(node, Player):
				player_node = node
	
	if not dummy_node:
		for node in get_parent().get_children():
			if is_instance_of(node, Dummy):
				dummy_node = node
		current_select = dummy_node


func _on_active():
	is_active = true
	current_select = dummy_node
			
func spread():
	player_node.harmful = 1

func _on_spread_end():
	for node in get_parent().get_children():
		if is_instance_of(node, Player):
			node.harmful = 0
			
func _physics_process(delta):
	super._physics_process(delta)
	if len(jump_dummies) > 0 and current_select == jump_dummies[0]:
		if jump_dummies[0].hit:
			var result = check_jump_result()
			if result:
				player_node.health = -1
			else:
				current_select = dummy_node
				jump_dummies[0].queue_free()

func check_jump_result():
	var distance = sqrt((current_select.position.x - player_node.position.x)**2 + (current_select.position.y - player_node.position.y)**2)
	if distance < 50:
		return true  # hit by jump
	else:
		return false

func jump():
	var _jump_dummy = VolkarJump.instantiate()
	get_parent().add_child(_jump_dummy)
	_jump_dummy.show()
	jump_dummies.append(_jump_dummy)
	jump_dummies[0].global_position = player_node.global_position
	current_select = jump_dummies[0]
	speed = 150
	
	
func create_spit(node):
	pass

func spit():
	for node in get_parent().get_children():
		if is_instance_of(node, Dummy) or is_instance_of(node, Player):
			create_spit(node)

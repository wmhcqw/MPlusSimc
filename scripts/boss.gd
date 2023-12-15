extends CharacterBody2D

class_name Boss

var speed = 55
var health = 100
const MAX_HEALTH = 100

var current_select = self
var rotations = []
var prompts = []
var spell_list = []
var cast_intervals = []
var cast_times = []
var channel_times = []
var is_friend = false
var is_boss = false

var cast_timer = Timer.new()  # rotation use
var casting_timer = Timer.new()  # casting use, like larzan's chasing
var channel_timer = Timer.new()  # channel use
var channel_bar = ProgressBar.new()

var health_bar = ProgressBar.new()

var current_rotations = 0
var is_casting = false  # is casting spell or not
var is_channeling = false  # is channeling a spell or not

var path_finder = NavigationAgent2D.new()

signal boss_cast

func _ready():
	pass

func _enter_tree():
	cast_timer.autostart = false
	cast_timer.one_shot = true
	cast_timer.timeout.connect(_run_rotations)
	add_child(cast_timer)
	cast_timer.start(5)  # cast after entering scenes in 5 second
	
	casting_timer.autostart = false
	casting_timer.one_shot = true
	casting_timer.timeout.connect(_finish_cast)
	add_child(casting_timer)
	
	channel_timer.autostart = false
	channel_timer.one_shot = true
	channel_timer.timeout.connect(_finish_channel)
	add_child(channel_timer)
	
	health_bar.show_percentage = false
	health_bar.modulate = Color.RED
	health_bar.max_value = MAX_HEALTH
	health_bar.size = Vector2(36, 2)
	health_bar.position = Vector2(-18, -23)
	add_child(health_bar)
	
	channel_bar.show_percentage = false
	channel_bar.visible = false
	channel_bar.modulate = Color.ORANGE
	channel_bar.max_value = 0
	channel_bar.size = Vector2(36, 2)
	channel_bar.position = Vector2(-18, -20)
	add_child(channel_bar)
	
	path_finder.avoidance_enabled = true
	path_finder.radius = 18
	path_finder.debug_enabled = true
	add_child(path_finder)
	
func get_movement_vector():
	var dir = Vector2.ZERO
	if not is_channeling:
		var node = current_select
		var distance = sqrt((node.position.x - position.x) ** 2 + (node.position.y - position.y)**2)
		if distance <= 25:
			pass
		elif node.health > 0:
			dir = to_local(path_finder.get_next_path_position())
	return dir


func _physics_process(_delta):
	var direction = Vector2.ZERO
	if current_select:
		path_finder.target_position = current_select.global_position
		var movement_vector = get_movement_vector()
		direction = movement_vector.normalized()
	velocity = direction * speed
	move_and_slide()

func _process(_delta):
	health_bar.value = health
	
	if is_channeling:
		channel_bar.visible = true
		channel_bar.value = channel_timer.wait_time - channel_timer.time_left
		
	if is_casting:
		channel_bar.visible = true
		channel_bar.value = casting_timer.time_left

func _run_rotations():
	cast(rotations[current_rotations])
	is_channeling = true
	channel_bar.fill_mode = 0
	channel_timer.start(channel_times[rotations[current_rotations]])
	channel_bar.visible = true
	channel_bar.max_value = channel_times[rotations[current_rotations]]
	current_rotations += 1
	if current_rotations > len(rotations)-1:
		current_rotations = 0
	cast_timer.start(cast_intervals[current_rotations])

func _finish_channel():
	is_channeling = false
	var pre_rotations = current_rotations - 1
	if pre_rotations < 0:
		pre_rotations = len(rotations) - 1
	is_casting = true
	casting_timer.start(cast_times[rotations[pre_rotations]])
	channel_bar.fill_mode = 0
	channel_bar.visible = true
	channel_bar.max_value = cast_times[rotations[pre_rotations]]
	
func _finish_cast():
	is_casting = false
	channel_bar.visible = false
	channel_bar.max_value = 0
	channel_bar.value = 0

func cast(spell_id):
	if not is_casting and not is_channeling:
		print("Casting ", spell_list[spell_id])
		boss_cast.emit()
		var spell = Callable(self, spell_list[spell_id])
		spell.call()  # boss cast different from player

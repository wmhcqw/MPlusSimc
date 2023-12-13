extends CharacterBody2D

class_name Monster

var speed = 50
var health = 100
const MAX_HEALTH = 100

var current_select = self
var rotations = []
var prompts = []
var spell_list = []
var cast_intervals = []
var is_friend = false
var is_boss = false

var cast_timer = Timer.new()
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
	cast_timer.start(1)
	
	health_bar.show_percentage = false
	health_bar.modulate = Color.RED
	health_bar.max_value = MAX_HEALTH
	health_bar.size = Vector2(36, 2)
	health_bar.position = Vector2(-18, -23)
	add_child(health_bar)
	
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
	path_finder.target_position = current_select.global_position
	var movement_vector = get_movement_vector()
	var direction = movement_vector.normalized()
	velocity = direction * speed
	move_and_slide()

func _process(_delta):
	health_bar.value = health

func _run_rotations():
	cast(rotations[current_rotations])
	current_rotations += 1
	if current_rotations > len(rotations)-1:
		current_rotations = 0
	cast_timer.start(cast_intervals[current_rotations])

func cast(spell_id):
	if not is_casting and not is_channeling:
		print("Casting ", spell_list[spell_id])
		boss_cast.emit()
		var spell = Callable(self, spell_list[spell_id])
		spell.call()  # boss cast different from player

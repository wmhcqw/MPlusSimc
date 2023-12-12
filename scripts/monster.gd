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

var cast_timer = Timer.new()
var health_bar = ProgressBar.new()

var current_rotations = 0
var is_casting = false  # is casting spell or not
var is_channeling = false  # is channeling a spell or not


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
	
	
func get_movement_vector():
	var x_movement_vector = 0.
	var y_movement_vector = 0.
	if not is_channeling:
		var node = current_select
		var distance = sqrt((node.position.x - position.x) ** 2 + (node.position.y - position.y)**2)
		if distance <= 25:
			pass
		elif node.health > 0:
			x_movement_vector = node.position.x - position.x
			y_movement_vector = node.position.y - position.y
	return Vector2(x_movement_vector, y_movement_vector)


func _process(_delta):
	var movement_vector = get_movement_vector()
	var direction = movement_vector.normalized()
	velocity = direction * speed
	move_and_slide()
	
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
		var spell = Callable(self, spell_list[spell_id])
		spell.call()  # boss cast different from player

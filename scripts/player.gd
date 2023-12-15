extends CharacterBody2D

class_name Player

var role = "player"
var speed = 50
var is_player_control = true
var death_note = ""

const MAX_HEALTH = 100
var health = 100
var harmful = 0

var current_select = self
var spell_list = []
var spell_cds = []
var is_gcd = false
var in_debuff = false
var is_friend = true

var health_bar = ProgressBar.new()

var gcd_timer = Timer.new()
var debuff_timer = Timer.new()
var cd_timer_1 = Timer.new()
var cd_timer_2 = Timer.new()
var cd_timer_3 = Timer.new()
var cd_timers = [cd_timer_1, cd_timer_2, cd_timer_3]

var cd_flag_1 = false
var cd_flag_2 = false
var cd_flag_3 = false
var cd_flags = [cd_flag_1, cd_flag_2, cd_flag_3]

func _ready():
	pass

func _enter_tree():
	
	# cd_timers
	for n in range(3):
		cd_timers[n].autostart = false
		cd_timers[n].one_shot = true
		add_child(cd_timers[n])
		
	cd_timers[0].timeout.connect(_on_cd_timer_1_timeout)
	cd_timers[1].timeout.connect(_on_cd_timer_2_timeout)
	cd_timers[2].timeout.connect(_on_cd_timer_3_timeout)
	
	# gcd timer
	gcd_timer.autostart = false
	gcd_timer.one_shot = true
	gcd_timer.wait_time = 1.0
	gcd_timer.timeout.connect(_on_gcd_timer_timeout)
	add_child(gcd_timer)
	
	# harmful debuff timer, need to disple
	debuff_timer.autostart = false
	debuff_timer.one_shot = true
	debuff_timer.wait_time = 1.0
	debuff_timer.timeout.connect(_on_debuff_timer_timeout)
	add_child(debuff_timer)
	
	health_bar.show_percentage = false
	health_bar.show_behind_parent = false
	health_bar.modulate = Color.GREEN
	health_bar.max_value = MAX_HEALTH
	health_bar.size = Vector2(36, 2)
	health_bar.position = Vector2(-18, -23)
	add_child(health_bar)

func get_movement_vector():
	var x_movement_vector = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement_vector = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward") 
	return Vector2(x_movement_vector, y_movement_vector)


func _process(_delta):
	var movement_vector = get_movement_vector()
	var direction = movement_vector.normalized()
	velocity = direction * speed
	move_and_slide()
	health_bar.value = health
	if Input.is_action_just_pressed("spell_1"):
		cast(0)
	elif Input.is_action_just_pressed("spell_2"):
		cast(1)
	elif Input.is_action_just_pressed("spell_3"):
		cast(2)
	check_harmful()

func check_harmful():
	if harmful == 1 and not in_debuff:
		in_debuff = true
		debuff_timer.start()

func _on_debuff_timer_timeout():
	health -= 10
	print(health)
	in_debuff = false


func cast(spell_id):
	if not is_gcd and not cd_flags[spell_id]:
		print("Casting ", spell_list[spell_id])
		var spell = Callable(self, spell_list[spell_id])
		var cast_result = spell.call(current_select)
		if cast_result:
			cd_timers[spell_id].start(spell_cds[spell_id])
			cd_flags[spell_id] = true
			is_gcd = true
			gcd_timer.start()
	elif not is_gcd and cd_flags[spell_id]:
		print("Spell not ready!")
	else:
		print("In GCD!")

func _on_gcd_timer_timeout():
	is_gcd = false
	print("GCD ready!")

func _on_cd_timer_1_timeout():
	cd_flags[0] = false
	print(spell_list[0], " ready!")

func _on_cd_timer_2_timeout():
	cd_flags[1] = false
	print(spell_list[1], " ready!")

func _on_cd_timer_3_timeout():
	cd_flags[2] = false
	print(spell_list[2], " ready!")

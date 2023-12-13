extends Node2D

var player_node: Player
var target_node: Player
var boss_node: Monster

@onready var hint: Label = $Label
@onready var player_health_bar: ProgressBar = $Player_Health
@onready var target_health_bar: ProgressBar = $Target_Health
@onready var spell_slot_1: Button = $spell_1
@onready var spell_slot_1_texture: TextureRect = $spell_1/TextureRect
@onready var spell_slot_1_cd: Label = $spell_1/Label
@onready var spell_slot_2: Button = $spell_2
@onready var spell_slot_2_texture: TextureRect = $spell_2/TextureRect
@onready var spell_slot_2_cd: Label = $spell_2/Label
@onready var spell_slot_3: Button = $spell_3
@onready var spell_slot_3_texture: TextureRect = $spell_3/TextureRect
@onready var spell_slot_3_cd: Label = $spell_3/Label

var text_hide_timer = Timer.new()



func _change_hint_text(spell_id):
	hint.text = boss_node.prompts[spell_id]
	hint.visible = true
	
func _hide_hint_text():
	hint.text = ""
	hint.visible = false

func _show_hint_text():
	hint.text = boss_node.prompts[boss_node.rotations[boss_node.current_rotations]]
	hint.visible = true
	text_hide_timer.start(5)


func _ready():
	spell_slot_1_texture.expand_mode = TextureRect.EXPAND_FIT_HEIGHT_PROPORTIONAL
	spell_slot_2_texture.expand_mode = TextureRect.EXPAND_FIT_HEIGHT_PROPORTIONAL
	spell_slot_3_texture.expand_mode = TextureRect.EXPAND_FIT_HEIGHT_PROPORTIONAL
	spell_slot_1_cd.visible = false
	spell_slot_2_cd.visible = false
	spell_slot_3_cd.visible = false
	
	text_hide_timer.autostart = false
	text_hide_timer.one_shot = true
	text_hide_timer.timeout.connect(_hide_hint_text)
	add_child(text_hide_timer)
	
	hint.visible = false
	hint.text = ""
	
	for node in get_parent().get_children():
		if is_instance_of(node, Player):
			if node.is_player_control:
				player_node = node
		if is_instance_of(node, Monster):
			if node.is_boss:
				boss_node = node
				
	if boss_node:
		boss_node.boss_cast.connect(_show_hint_text)


func _process(delta):
	
	if player_node:
		spell_slot_1_texture.texture = load("res://resources/sprite/" + player_node.spell_list[0] + ".png")
		spell_slot_2_texture.texture = load("res://resources/sprite/" + player_node.spell_list[1] + ".png")
		spell_slot_3_texture.texture = load("res://resources/sprite/" + player_node.spell_list[2] + ".png")
		
		if player_node.cd_flags[0]:
			spell_slot_1_texture.modulate = Color.RED
			spell_slot_1_cd.visible = true
			spell_slot_1_cd.text = str(round(player_node.cd_timers[0].time_left))
		else:
			spell_slot_1_texture.modulate = Color.WHITE
			spell_slot_1_cd.visible = false
			
		if player_node.cd_flags[1]:
			spell_slot_2_texture.modulate = Color.RED
			spell_slot_2_cd.visible = true
			spell_slot_2_cd.text = str(round(player_node.cd_timers[1].time_left))
		else:
			spell_slot_2_texture.modulate = Color.WHITE
			spell_slot_2_cd.visible = false
			
		if player_node.cd_flags[2]:
			spell_slot_3_texture.modulate = Color.RED
			spell_slot_3_cd.visible = true
			spell_slot_3_cd.text = str(round(player_node.cd_timers[2].time_left))
		else:
			spell_slot_3_texture.modulate = Color.WHITE
			spell_slot_3_cd.visible = false
			
		
		player_health_bar.modulate = Color.GREEN
		player_health_bar.value = player_node.health
		player_health_bar.max_value = player_node.MAX_HEALTH
		player_health_bar.show_percentage = false
		
		target_node = player_node.current_select
		target_health_bar.modulate = Color.GREEN if target_node.is_friend else Color.RED
		target_health_bar.value = target_node.health
		target_health_bar.max_value = target_node.MAX_HEALTH
		target_health_bar.show_percentage = false
		

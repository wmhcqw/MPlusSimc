extends Node2D

@onready var player_node: Healer = $Healer
@onready var dummy_node: Dummy = $Volkar_dummy
@onready var death_menu = $HUD/DeathMenu
@onready var death_hint = $HUD/DeathMenu/DeathNote

@onready var totem_1 = $Volkar_env1
@onready var totem_2 = $Volkar_env2
@onready var totem_3 = $Volkar_env3


func _ready():
	dummy_node.target_positions = [dummy_node.global_position, totem_1.global_position, totem_2.global_position, totem_3.global_position]
	
func _process(delta):
	if player_node.health <= 0:
		get_tree().paused = true
		death_menu.show()
		if len(player_node.death_note) > 0:
			death_hint.text = player_node.death_note
	else:
		death_menu.hide()
		get_tree().paused = false
		

func _physics_process(delta):
	pass

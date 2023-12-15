extends Node2D

@onready var player_node: Healer = $Healer
@onready var death_menu = $HUD/DeathMenu
@onready var death_hint = $HUD/DeathMenu/DeathNote


func _process(delta):
	if player_node.health <= 0:
		get_tree().paused = true
		death_menu.show()
		if len(player_node.death_note) > 0:
			death_hint.text = player_node.death_note
		else:
			death_hint.text = "中流血记得驱散！"
	else:
		death_menu.hide()
		get_tree().paused = false
		

func _physics_process(delta):
	for node in get_children():
		if is_instance_of(node, LarzanEnv):
			if node.hit:
				player_node.health = -1
				player_node.death_note = "别踩紫水！也别让boss踩到紫水！"

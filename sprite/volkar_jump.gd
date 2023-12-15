extends CharacterBody2D

var hit = false
var health = 100


func _physics_process(delta):
	if move_and_slide():
		print(get_last_slide_collision().get_collider())
		hit = true

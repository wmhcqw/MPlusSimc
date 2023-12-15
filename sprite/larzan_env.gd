extends CharacterBody2D

class_name LarzanEnv

var hit = false


func _physics_process(delta):
	velocity = Vector2.ZERO
	if move_and_slide():
		hit = true

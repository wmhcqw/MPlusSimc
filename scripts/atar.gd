extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_lazan_pressed():
	get_tree().change_scene_to_file("res://lazan.tscn")
	

func _on_maid_pressed():
	get_tree().change_scene_to_file("res://maid.tscn")
	

func _on_valokar_pressed():
	get_tree().change_scene_to_file("res://volkar.tscn")
	

func _on_yazma_pressed():
	get_tree().change_scene_to_file("res://yazma.tscn")
	

func _on_back_pressed():
	get_tree().change_scene_to_file("res://select.tscn")

extends Node2D

func _ready():
	if Input.is_action_just_pressed("click"):
		get_tree().change_scene("res://scenes/cell_scene_final.tscn")

func _on_VideoPlayer_finished():
	get_tree().change_scene("res://scenes/cell_scene_final.tscn")

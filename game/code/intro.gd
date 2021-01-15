extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if Input.is_action_just_pressed("click"):
		get_tree().change_scene("res://scenes/start_ui.tscn")

func _on_VideoPlayer_finished():
	get_tree().change_scene("res://scenes/start_ui.tscn")

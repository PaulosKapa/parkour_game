extends Node2D
onready var next_scene = preload("res://scenes/cell_scene_final.tscn")
#func _ready():
#	if Input.is_action_just_pressed("click"):
#		get_tree().change_scene("res://scenes/cell_scene_final.tscn")

func _on_VideoPlayer_finished():
	Global.goto_scene(next_scene)


func _process(delta):
	if !($VideoPlayer.is_playing()):
		return
	if(Input.is_key_pressed(KEY_SPACE)):
		self._on_VideoPlayer_finished()
	
		

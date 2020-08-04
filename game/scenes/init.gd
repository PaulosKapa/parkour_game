extends Spatial
var stage = preload("res://scenes/1st_scene.tscn")

func _ready():
	Global.goto_scene(stage)

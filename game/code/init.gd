extends Spatial
var stage = preload("res://scenes/test_scene.tscn")

func _ready():
	Global.goto_scene(stage)

extends Spatial
var firststage = preload("res://scenes/1st_scene.tscn")
var character = preload("res://scenes/Player_rigged_kinematic.tscn")
func _ready():
	get_tree().add_child(character)
	Global.goto_scene(firststage)

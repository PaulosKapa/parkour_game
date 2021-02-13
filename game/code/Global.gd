extends Node
#onready var player = get_tree().get_root().get_node("/root/level/Player")
var current_scene = null



func _ready():
	SettingsData.load_settings()
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)

func goto_scene(scene):
	call_deferred("_deferred_goto_scene", scene)

func _deferred_goto_scene(scene):
	if(is_instance_valid(current_scene)):
		#It seems that, to avoid commingling of Scenes, you have to explicitly remove the current one from the SceneTree
		get_tree().get_root().remove_child(current_scene)
		current_scene.free()
	current_scene = scene.instance()
	print("USER dir:",OS.get_user_data_dir())
	var _error_status = Directory.new().remove("user://saves/progress.save")
	_error_status = Directory.new().remove("user://saves")
	
	get_tree().get_root().add_child(current_scene)
	get_tree().set_current_scene(current_scene)

#for_sure_player passed in because Godot keeps reporting "/root/level/Player" node not found
#when line 2 of this file executes
#checkpoint_name: String
func save_game_info(checkpoint_name,for_sure_player):
	#This will call the save() method of the singleton that holds game progress
	print("Called Global.save_game_info()")
	GameData.set_player_status(checkpoint_name,for_sure_player)
	GameData.save("user://saves")
	pass

extends Area

func _on_Area_body_entered(body):
	if body.is_in_group("Player"):
		Engine.time_scale = 1
		#Restore from checkpoint if the player lands in this lava pit
		#Both calls probably should be replaced by a single "body.health = 0"
		#(FLJ, 9/1/2020)
		GameData.restore("user://saves")
		get_tree().reload_current_scene()


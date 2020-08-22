extends KinematicBody

func _process(delta):
	var slide_count = get_slide_count()
	
	for i in slide_count:
		var col = get_slide_collision(i)
		if(col):
			var groups = col.collider.get_groups()
			if(groups.has("Player")):
				get_tree().reload_current_scene()
				print("Player was hurt by touching an enemy!")

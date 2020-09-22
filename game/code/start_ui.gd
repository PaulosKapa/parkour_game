extends Spatial

func _ready():
	pass

func _on_door_clickable_area_input_event(camera, event, click_position, click_normal, shape_idx):
	var mouse_click = event as InputEventMouseButton
	# Detecting LMB clicks only
	if mouse_click and mouse_click.button_index == 1 and mouse_click.pressed:
		# Not sure what the map selection scene is, some names seem quite questionable
		get_tree().change_scene("res://scenes/1st_scene.tscn")

func _on_window_clickable_area_input_event(camera, event, click_position, click_normal, shape_idx):
	var mouse_click = event as InputEventMouseButton
	# Detecting LMB clicks only
	if mouse_click and mouse_click.button_index == 1 and mouse_click.pressed:
		# Call any saves or frees here if needed
		# I haven't looked at all the code so not sure
		get_tree().quit()

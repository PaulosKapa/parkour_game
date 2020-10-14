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


func _on_clickable_area_mouse_entered():
	$window.get_surface_material(0).set_emission(Color(1,1,1))
func _on_clickable_area_mouse_exited():
	$window.get_surface_material(0).set_emission(Color(0.45,0.45,0.45))
	
func _on_clickable_area1_mouse_entered():
	$door_laser.get_surface_material(0).set_albedo(Color(0,1,0))
	$door_laser.get_surface_material(0).set_emission(Color(0,1,0))

func _on_clickable_area1_mouse_exited():
	$door_laser.get_surface_material(0).set_albedo(Color(0.78, 0.09, 0.09))
	$door_laser.get_surface_material(0).set_emission(Color(1,0,0))

extends Spatial
#to figure out what stage to put on the cell
var stage = 1

func _ready():
	$neon_lights_start_ui/lights.start()
func _process(delta):
	$power_off_logo.rotate_y(rad2deg(0.0001))

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
		get_tree().change_scene("res://scenes/SettingsDemo.tscn")


func _on_clickable_area_mouse_entered():
	$settings.show()
	#$window.get_surface_material(0).set_emission(Color(1,1,1))
func _on_clickable_area_mouse_exited():
	$settings.hide()
	#$window.get_surface_material(0).set_emission(Color(0.45,0.45,0.45))
	
func _on_clickable_area1_mouse_entered():
	match stage:
		1: $cell_scene.show()
	#$door_laser.get_surface_material(0).set_albedo(Color(0,1,0))
	#$door_laser.get_surface_material(0).set_emission(Color(0,1,0))

func _on_clickable_area1_mouse_exited():
	match stage:
		1: $cell_scene.hide()
	#$door_laser.get_surface_material(0).set_albedo(Color(0.78, 0.09, 0.09))
	#$door_laser.get_surface_material(0).set_emission(Color(1,0,0))


func _on_clickable_area_bed_input_event(camera, event, click_position, click_normal, shape_idx):
	var mouse_click = event as InputEventMouseButton
	# Detecting LMB clicks only
	if mouse_click and mouse_click.button_index == 1 and mouse_click.pressed:
		# Call any saves or frees here if needed
		# I haven't looked at all the code so not sure
		get_tree().quit()



func _on_clickable_area_bed_mouse_entered():
	#$bed.get_surface_material(0).set_albedo(Color(0.6, 0.6, 0.6))
	$power_off_logo.show()
	
func _on_clickable_area_bed_mouse_exited():
	$power_off_logo.hide()
	#$bed.get_surface_material(0).set_albedo(Color(0.24, 0.2, 0.19))

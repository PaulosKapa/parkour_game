extends Spatial
#to figure out what stage to put on the cell
onready var first_scene = preload("res://scenes/1st_scene.tscn")
var settings = preload("res://scenes/SettingsDemo.tscn")
onready var this_scene = get_node("/root/cell")
var stage = 1
var rot = 0
func _ready():
	$neon_lights_start_ui/lights.start()
func _process(delta):
	rotate1()
	$power_off_logo.rotate_y(rad2deg(0.0001))

func _on_door_clickable_area_input_event(camera, event, click_position, click_normal, shape_idx):
	var mouse_click = event as InputEventMouseButton
	# Detecting LMB clicks only
	if mouse_click and mouse_click.button_index == 1 and mouse_click.pressed:
		# Not sure what the map selection scene is, some names seem quite questionable
		Global.goto_scene(first_scene)

func _on_window_clickable_area_input_event(camera, event, click_position, click_normal, shape_idx):
	var mouse_click = event as InputEventMouseButton
	# Detecting LMB clicks only
	if mouse_click and mouse_click.button_index == 1 and mouse_click.pressed:
		# Call any saves or frees here if needed
		# I haven't looked at all the code so not sure
		#get_tree().root.add_child(settings.instance())
		#get_tree().root.remove_child(this_scene)
		#this_scene.queue_free()
		Global.goto_scene(settings)

func _on_clickable_area_mouse_entered():
	rot = 1
	$settings.show()
	$sound.play()
	#$window.get_surface_material(0).set_emission(Color(1,1,1))
func _on_clickable_area_mouse_exited():
	rot = 0
	$settings.hide()
	#$window.get_surface_material(0).set_emission(Color(0.45,0.45,0.45))
	
func _on_clickable_area1_mouse_entered():
	rot = 1
	$sound.play()
	$door_laser.hide()
	match stage:
		1: $cell_scene.show()
	#$door_laser.get_surface_material(0).set_albedo(Color(0,1,0))
	#$door_laser.get_surface_material(0).set_emission(Color(0,1,0))

func _on_clickable_area1_mouse_exited():
	rot = 0
	$door_laser.show()
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
	rot = 1
	$sound.play()
	#$bed.get_surface_material(0).set_albedo(Color(0.6, 0.6, 0.6))
	$power_off_logo.show()
	
func _on_clickable_area_bed_mouse_exited():
	rot = 0
	$power_off_logo.hide()
	#$bed.get_surface_material(0).set_albedo(Color(0.24, 0.2, 0.19))

func rotate1():
	if rot == 1:
		$Node2D/Viewport/Spatial/cursor/Cube2.rotate_y(rad2deg(0.001))

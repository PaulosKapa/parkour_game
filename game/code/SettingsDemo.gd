extends Spatial
onready var settings = get_node(".")
var first = ("res://scenes/start_ui.tscn")

func _on_Area_input_event(camera, event, click_position, click_normal, shape_idx):
	var mouse_click = event as InputEventMouseButton
	# Detecting LMB clicks only
	if mouse_click and mouse_click.button_index == 1 and mouse_click.pressed:
		#get_tree().root.add_child(first.instance())
		#get_tree().root.remove_child(settings)
		#settings.queue_free()
		get_tree().change_scene(first)


func _on_Area_mouse_entered():
	$tsk1.play()

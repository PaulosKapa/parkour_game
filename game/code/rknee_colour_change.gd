extends MeshInstance

onready var player = get_node("/root/level/Player")
func _process(delta):
	if player.health==player.health-2:
		$".".get_surface_material(0).set_albedo(Color(1, 0, 0))
		$playernop/colour_change.start()

func _on_colour_change_timeout():
	$".".get_surface_material(0).set_albedo(Color(0, 1, 0))
	$playernop/colour_change.stop()

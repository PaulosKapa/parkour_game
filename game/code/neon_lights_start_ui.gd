extends Spatial

var light = 0
var dark = 1

func _ready():
	$lights.start()

func _on_lights_timeout():
	$Text.get_surface_material(0).set_albedo(Color(0,0,0))
	$Text.get_surface_material(0).set_emission(Color(0,0,0))
	$lights.stop()
	if dark == 1:
			$Text.get_surface_material(0).set_albedo(Color(0.05,0.83,0.72))
			$Text.get_surface_material(0).set_emission(Color(0,0.67,1))
			$lights.start()
			dark = 0
	else:
		$lights_on.start()
		dark = 0

func _on_lights_on_timeout():
	$Text.get_surface_material(0).set_albedo(Color(0.05,0.83,0.72))
	$Text.get_surface_material(0).set_emission(Color(0,0.67,1))
	$lights_on.stop()
	if light == 1:
		$lights.start()
		light = 0
	else:
		$lights_on.start()
		light = 1

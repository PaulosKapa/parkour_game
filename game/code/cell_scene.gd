extends Spatial

func _ready():
	$lights_roof/onoff/OmniLight.hide()
	$lights_roof/onoff/Cylinder001.get_surface_material(0).set_emission_energy(0)
	$lights_roof/onoff/onoff.start()
	
func _on_onoffdown_timeout():
	$lights_roof/onoffdown/OmniLight.show()
	$lights_roof/onoffdown/Cylinder001.get_surface_material(0).set_emission_energy(8)
	$lights_roof/onoffdown/onoffdown.stop()
	$lights_roof/onofffinal/OmniLight.hide()
	$lights_roof/onofffinal/Cylinder001.get_surface_material(0).set_emission_energy(0)
	$lights_roof/onofffinal/onofffinal.start()
	
func _on_onofffinal_timeout():
	$lights_roof/onofffinal/OmniLight.show()
	$lights_roof/onofffinal/Cylinder001.get_surface_material(0).set_emission_energy(8)
	$lights_roof/onoff/Cylinder001.get_surface_material(0).set_emission_energy(0)
	$lights_roof/onofffinal/onofffinal.stop()
	$lights_roof/onoff/OmniLight.hide()
	$lights_roof/onoff/onoff.start()
	
func _on_onoff_timeout():
	$lights_roof/onoff/OmniLight.show()
	$lights_roof/onoffdown/OmniLight.hide()
	$lights_roof/onoff/Cylinder001.get_surface_material(0).set_emission_energy(8)
	$lights_roof/onoffdown/Cylinder001.get_surface_material(0).set_emission_energy(0)
	$lights_roof/onoffdown/onoffdown.start()
	$lights_roof/onoff/onoff.stop()

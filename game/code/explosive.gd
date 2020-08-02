extends StaticBody

func explode():
	print("boom")
	$Area6/Particles.set_emitting(true)
	$StaticBody/CollisionShape.disabled = false
	$Timer.start()
	$Timer2.start()

func _on_Timer_timeout():
	$StaticBody/CollisionShape.disabled = true
	$MeshInstance2.hide()
	$CollisionShape.disabled=true
	$Area.show()
	$Area/CollisionShape.disabled=true


func _on_Timer2_timeout():
	$Area6/Particles.hide()

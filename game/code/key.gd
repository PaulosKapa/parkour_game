extends Area
var door = 0
signal unlock

func _process(_delta):
	rotate_y(rad2deg(0.001))

func _on_Spatial_body_entered(body):
	if body.is_in_group("Player") or body.is_in_group("bullet"):

		$delet.start()

func _on_delet_timeout():
	emit_signal("unlock")
	$delet.stop()
	queue_free()

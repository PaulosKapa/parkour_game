extends Area

func _on_Area6_body_entered(body):
	if body.is_in_group("Player"):
		$Particles.set_emitting(true)
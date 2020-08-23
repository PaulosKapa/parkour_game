extends Area

func die():
	return

func _on_Area_body_entered(body):
	if body.is_in_group("Player"):
		$AnimationPlayer.play("enemy")


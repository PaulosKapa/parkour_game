extends Area

signal health_regen

func _on_Area_body_entered(body):
	if body.is_in_group("Player") and body.health<3:
		body.health=body.health+1
		emit_signal("health_regen")
		queue_free()

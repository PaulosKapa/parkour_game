extends Area

onready var jump = get_tree().get_root().get_node("/root/level/KinematicBody")

func _on_Area6_body_entered(body):
	if body.is_in_group("Player"):
		jump.accel=1000
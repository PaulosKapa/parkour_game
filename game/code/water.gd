extends Area
onready var sp= get_node("/root/level/Player")

func _on_Area4_body_entered(body):
	if body.is_in_group("Player"):
		sp.speed_factor=0.05
		sp.jump_factor=0.2

func _on_Area4_body_exited(body):
	if body.is_in_group("Player"):
		sp.speed_factor=1.0
		sp.jump_factor=1.0

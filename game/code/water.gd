extends Area
onready var sp= get_node("/root/level/Player")

func _on_Area4_body_entered(body):
	if body.is_in_group("Player"):
		sp.gravity=-1800
		sp.sp=2000

func _on_Area4_body_exited(body):
	if body.is_in_group("Player"):
		sp.gravity=-900
		sp.sp=10000

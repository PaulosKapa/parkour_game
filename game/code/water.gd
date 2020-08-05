extends Area
onready var sp= get_node("/root/level/Player")

func _on_Area4_body_entered(body):
	if body.is_in_group("Player"):
		sp.sp=500
		sp.jum=100

func _on_Area4_body_exited(body):
	if body.is_in_group("Player"):
		sp.sp=10000
		sp.jum=500

extends Area
onready var expl= get_node("/root/level/RigidBody")


func _on_Area_body_entered(body):
	if body.is_in_group("Player"):
		expl.explode()
	

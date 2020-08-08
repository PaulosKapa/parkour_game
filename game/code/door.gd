extends Area
var unl_door=0

func _on_Area5_body_entered(body):
	if unl_door==1 and body.is_in_group("Player"):
		$AnimationPlayer.play("door")

func _on_key_unlock():
	unl_door=1

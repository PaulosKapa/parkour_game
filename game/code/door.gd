extends Area
var unl = 0
func _on_key_unlock():
	unl = 1

func _on_Area_body_entered(body):
	if body.is_in_group("Player") and unl == 1:
		$StaicBody/AnimationPlayer.play("door")


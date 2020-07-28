extends Area


func _on_Area5_body_entered(body):
		print(5)
		$AnimationPlayer.play("door")

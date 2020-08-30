extends Area
class_name Checkpoint
var _hit = false

func _on_Checkpoint_body_entered(body):
	if not("Player" in body.name):
		return
	#prevent double hits
	if _hit:
		return
	Global.save_game_info(name,body)
	self.queue_free() #safe self-deletion

extends Area
class_name Checkpoint

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var _hit = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Checkpoint_body_entered(body):
	if not("Player" in body.name):
		return
	#prevent double hits
	if _hit:
		return
	Global.save_game_info()
	self.queue_free() #safe self-deletion

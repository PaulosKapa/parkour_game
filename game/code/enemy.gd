extends StaticBody
onready var sho = get_node("/root/level/Spatial/StaticBody/Spatial")
onready var kil = get_node("/root/level/Player")
var space_state
var target

func die():
	kil.kill()
	queue_free()

func _ready():
	space_state = get_world().direct_space_state

func _process(delta):
	if target:
		look_at(target.global_transform.origin, Vector3.UP)
		sho.shoot()
					
func _on_Area_body_entered(body):
	if body.is_in_group("Player"):
		target= body
func _on_Area_body_exited(body):
	if body.is_in_group("Player"):
		target= null

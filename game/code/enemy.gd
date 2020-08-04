extends StaticBody
onready var sho = get_node("/root/level/Spatial/StaticBody/Spatial")
var space_state
var target

func die():
	queue_free()

func _ready():
	space_state = get_world().direct_space_state
	add_to_group("enemy")
func _process(delta):
	if target:
		look_at(target.global_transform.origin, Vector3.UP)
		var result = space_state.intersect_ray(global_transform.origin, target.global_transform.origin)
		if result.collider.is_in_group("Player"):
			sho.shoot()
func _on_Area_body_entered(body):
	if body.is_in_group("Player"):
		target= body
func _on_Area_body_exited(body):
	if body.is_in_group("Player"):
		target= null

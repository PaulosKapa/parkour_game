extends StaticBody
onready var sho = get_node("/root/level/Spatial4/StaticBody/sentry/pivot_point_sentry/Spatial")
onready var kil = get_node("/root/level/Player")
onready var laser = get_node("/root/level/Spatial4/StaticBody/sentry/pivot_point_sentry/Plane001/rotation_point")
var space_state
var target
var health=3
func die(damage):
	health=health-damage
	if health==0:
		kil.kill()
		queue_free()

func _ready():
	space_state = get_world().direct_space_state

		
func _process(_delta):
	if target:
		$sentry/pivot_point_sentry.look_at(target.global_transform.origin, Vector3.UP)
		$sentry/pivot_point_sentry.rotate_object_local(Vector3(0, 1, 0), PI)
		$sentry/pivot_point_sentry.rotate_object_local(Vector3(0, 0, 1), PI/2)
		sho.shoot(target)
					
func _on_Area_body_entered(body):
	# start laser show
	if body.is_in_group("Player"):
		target= body
		laser.scale_object_local(Vector3(1, 200, 1))

func _on_Area_body_exited(body):
	if body.is_in_group("Player"):
		target= null
		#laser.orthonormalize() undid the "scale to (0.006,0.006,0.006)" as well
		laser.scale_object_local(Vector3(1, .002, 1)) #undoes the scale operation done when entered

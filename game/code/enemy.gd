extends StaticBody
onready var sho = get_node("/root/level/Spatial4/StaticBody/Spatial")
onready var kil = get_node("/root/level/Player")
onready var laser = get_node("./sentry/Plane001/Cylinder001/rotation_point")
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
		$sentry/Plane001.look_at(target.global_transform.origin, Vector3.UP)
		$sentry/Plane001.rotate_object_local(Vector3(0, 1, 0), PI)
		$sentry/Plane001.rotate_object_local(Vector3(0, 0, -1), PI/2)
		#$TURRET/Cylinder/Torus001.rotate_z(deg2rad(15))
		sho.shoot(target)
					
func _on_Area_body_entered(body):
	# start laser show
	if body.is_in_group("Player"):
		target= body
		$AnimationPlayer.play("laser")
		laser.scale_object_local(Vector3(1, 500, 1))

func _on_Area_body_exited(body):
	if body.is_in_group("Player"):
		target= null
		$AnimationPlayer.play("LASER_CL")
		laser.orthonormalize()

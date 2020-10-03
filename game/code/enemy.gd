extends StaticBody
onready var sho = get_node("/root/level/Spatial4/StaticBody/Spatial")
onready var kil = get_node("/root/level/Player")
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
		$TURRET/Cylinder.look_at(target.global_transform.origin, Vector3.UP)
		$TURRET/Cylinder.rotate_object_local(Vector3(0, 1, 0), PI)
		$TURRET/Cylinder.rotate_object_local(Vector3(0, 0, -1), PI/2)
		$TURRET/Cylinder/Torus001.rotate_z(deg2rad(15))
		sho.shoot(target)
					
func _on_Area_body_entered(body):
	if body.is_in_group("Player"):
		target= body
		$AnimationPlayer.play("laser")
func _on_Area_body_exited(body):
	if body.is_in_group("Player"):
		target= null
		$AnimationPlayer.play("LASER_CL")
		

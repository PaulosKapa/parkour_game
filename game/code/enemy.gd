extends StaticBody
onready var sho = $sentry/pivot_point_sentry/gun
onready var sentry = "."
onready var kil = get_node("/root/level/Player")
onready var laser = $sentry/pivot_point_sentry/Plane001/rotation_point
var shoot_yes = 1
var reticle_scale
var reticle_xlate
var space_state
var target
var health=3
var beam_length = 200.0
var inactive_transform
func die(damage):
	health=health-damage
	match health:
		0: 
			kil.kill() 
			$explosion.set_emitting(true)
			$damage.hide()
			$sentry.hide()
			$explosion2.play()
			sho.cant_shoot_var=1
			$CollisionShape2.queue_free()
			$CollisionShape4.queue_free()
			$death.start()
		2: $damage.set_emitting(true)

func _ready():
	space_state = get_world().direct_space_state
	reticle_scale = laser.global_transform.basis.get_scale()*2.0
	reticle_xlate = laser.global_transform.origin*3.0
	inactive_transform = laser.transform
		
func _process(_delta):
	
			
	if target and health>0:
		$sentry/pivot_point_sentry.look_at(target.global_transform.origin, Vector3.UP)
		$sentry/pivot_point_sentry.rotate_object_local(Vector3(0, 1, 0), PI)
		$sentry/pivot_point_sentry.rotate_object_local(Vector3(0, 0, 1), PI/2)
		
		var result = space_state.intersect_ray($sentry/pivot_point_sentry.global_transform.origin, target.global_transform.origin,
		 [self])
		if !result.empty():
			var dist = result.position.distance_to($sentry/pivot_point_sentry.global_transform.origin)/reticle_scale.y + reticle_xlate.y
			set_beam_length(dist)
		
#		var from_pt = ($sentry/pivot_point_sentry.global_transform.origin - reticle_xlate)/reticle_xform.y
#		var to_pt = (target.global_transform.origin  - reticle_xlate )/reticle_xform.y
#		from_pt.z = to_pt.z
#		var dist = from_pt.distance_to(to_pt)
#		set_beam_length(dist)
		sho.shoot(target)
					
func _on_Area_body_entered(body):
	# start laser show
	if body.is_in_group("Player"):
		target= body
		laser.translate_object_local(Vector3(0,-beam_length,0))
		laser.scale_object_local(Vector3(1, beam_length, 1))
		

func _on_Area_body_exited(body):
	if body.is_in_group("Player"):
		target= null
		#simply return it to its inactive position, rotation, and scale
		laser.transform = inactive_transform
		

func set_beam_length(new_length):
	if new_length == beam_length:
		return
	#undo the old length:
	laser.scale_object_local(Vector3(1, 1.0/beam_length, 1)) 
	laser.translate_object_local(Vector3(0,beam_length,0))
	#set the new length:
	beam_length = new_length
	#and apply it:
	laser.translate_object_local(Vector3(0,-beam_length,0))
	laser.scale_object_local(Vector3(1, beam_length, 1))
	
func _on_death_timeout():
	queue_free()

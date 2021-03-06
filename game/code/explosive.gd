extends StaticBody
onready var area_blast = $Area6
onready var play = get_node("/root/level/Player")
export(float) var blast_radius = 200.0
export(float) var blast_power = 20
var explode = 1
var _original_scale
var _current_scale
#signal blasted

var _thrown_objects = []
func explode():
	$exploding.play()
	var blasts = area_blast.get_overlapping_bodies()
	for b in blasts:
		if b.is_in_group("Player"):
			b.health-= explode
	$CollisionShape.disabled=true
	$Area2/CollisionShape.disabled=false
	$Area6/Particles.set_emitting(true)
	throw_objects_in_radius()
	$Timer.start()
	$explosive_barrel.queue_free()

func _on_Timer_timeout():
	queue_free()
	#_settle_thrown_objects()



#the method comes from the upper part of http://www.iforce2d.net/b2dtut/explosions
func throw_objects_in_radius():
	explode = 1
	var numRays = 16
	var center = global_transform.origin
	var space_state = get_world().direct_space_state
	for i in range(0,numRays):
		var angle = (i / (numRays as float)) * 2.0*PI
		var rayDir = Vector3(cos(angle),sin(angle),0)
		var rayEnd = center + blast_radius * rayDir
		# use global coordinates, not local to node
		var result = space_state.intersect_ray(center, rayEnd,[self])
		if(!result):
			continue
		if(!result.collider):
			continue
		throw_one_object(result.collider,center, result.position)
	if _thrown_objects.empty():
		return
	for objet in _thrown_objects:
		objet.scan_finished()
	_thrown_objects.clear()
		
		
#to_throw : Object (one of potentially many) to be thrown by the explosion	
#blastCenter : Vector3	
#applyPoint : Vector3 where the RayCast(slice of the explosion) hit to_throw
func throw_one_object(to_throw,blastCenter,applyPoint):
	#if to_throw in _thrown_objects:
	#	return
	applyPoint.z = to_throw.global_transform.origin.z
	blastCenter.z = applyPoint.z
	var blastDir = applyPoint - blastCenter
#	if blastDir.y <= 0:
#		blastDir.y *= -1.0
	if blastDir.y == 0:
		blastDir.y = abs(blastDir.x)
	var distance = blastDir.length()
	#ignore bodies exactly at the blast point - blast direction is undefined
	if ( distance == 0 ):  
		return
	if (distance < .8):
		distance = .995
	var invDistance = 1 / distance
	var impulseMag = blast_power * invDistance * invDistance
	
	var overall = impulseMag * blastDir.normalized()
	if to_throw.has_method("apply_impulse"):
		#the point argument is local to to_throw 
		var localApplyPoint = applyPoint-to_throw.global_transform.origin
		to_throw.apply_impulse(localApplyPoint,overall)


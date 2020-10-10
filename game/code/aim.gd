extends Spatial
onready var animation= get_node("/root/level/Player/animation")
enum {FACING_LEFT, FACING_RIGHT}
var facing = FACING_LEFT

var ray_origin = Vector3()
var ray_target=Vector3()

onready var armswing_length = $AnimationPlayer.get_animation("modelsaim").length;

onready var cam = get_node("/root/level/Player/InterpolatedCamera")

func _physics_process(_delta):
	ray_origin = cam.project_ray_origin(get_viewport().get_mouse_position())
	ray_target = cam.project_ray_normal(get_viewport().get_mouse_position())*100000
	
	var space_state = get_world().direct_space_state
	var ray = space_state.intersect_ray(ray_origin,ray_target,[self],2,true,true)
	
	if ray:
		var ray_collision_point = ray.position
		var object_position = global_transform.origin
		ray_collision_point = ray_collision_point - object_position
		
		var angle = -Vector2(ray_collision_point.x, ray_collision_point.y).angle_to(Vector2(-1, 0))
		
		if facing == FACING_RIGHT:
			if(angle <= 0):
				angle = -(PI+angle)
			else:
				angle = PI-angle
			pass
	
			
		if($AnimationPlayer.is_playing()):
			return
			
		#for the "aim" animation, -PI/2 is "top" - corresponds to length in secs
		#PI/2 is "bottom" - corresponds to 0 seconds
		#hence this formula	
		var frame = max(0,(PI/2-angle)/PI)
		frame = min(frame,1.0)*armswing_length
		
		#now, seek to that frame of the "aim" animation
		$AnimationPlayer.current_animation = "modelsaim"
		$AnimationPlayer.seek(frame,true)
		$AnimationPlayer.stop()
		
		if(abs(angle) > PI/2.0 && facing == FACING_RIGHT):
			$AnimationPlayer.play("cw")
#			animation.play("rotate_cw")
			facing = FACING_LEFT
			
		elif(abs(angle) > PI/2.0 && facing == FACING_LEFT):
			$AnimationPlayer.play("ccw")
#			animation.play("rotate_ccw")
			facing = FACING_RIGHT

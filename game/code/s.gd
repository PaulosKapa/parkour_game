extends Spatial
enum {FACING_LEFT, FACING_RIGHT}

var facing = FACING_LEFT

var ray_origin = Vector3()
var ray_target=Vector3()

onready var cam = get_node("/root/level/InterpolatedCamera")

func _physics_process(delta):
	ray_origin = cam.project_ray_origin(get_viewport().get_mouse_position())
	ray_target = cam.project_ray_normal(get_viewport().get_mouse_position())*100000
	
	var space_state = get_world().direct_space_state
	var ray = space_state.intersect_ray(ray_origin,ray_target,[self],2,true,true)
	
	if ray:
		var ray_collision_point = ray.position
		var object_position = global_transform.origin
		ray_collision_point = ray_collision_point - object_position
		var angle = -Vector2(ray_collision_point.x, ray_collision_point.y).angle_to(Vector2(-1, 0))
		
		if($AnimationPlayer.is_playing()):
			return
		
		if(abs(angle) < 1.5 && facing == FACING_RIGHT):
			$AnimationPlayer.play("rotate_cw")
			facing = FACING_LEFT
			
		elif(abs(angle) > 1.5 && facing == FACING_LEFT):
			$AnimationPlayer.play("rotate_ccw")
			facing = FACING_RIGHT

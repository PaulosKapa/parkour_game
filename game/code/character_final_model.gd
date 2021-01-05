extends KinematicBody

var vel= Vector3(0,0,0)
var gravity=-900
var jum= 500
var sp = 10000
const leg_force= 500
var accel = 0
var last_trans = translation
var physics_delta = 0;
var kill_var=0
var health=3
enum {FACING_LEFT, FACING_RIGHT}
var facing = FACING_LEFT
var cant_dash=0
onready var gun = $Armature/Skeleton/gun_holder/w
onready var anim_player = $AnimationPlayer1
var _collisions = []
export (NodePath) var camio
var ray_origin = Vector3()
var ray_target=Vector3()
onready var armswing_length = $AnimationPlayer4.get_animation("flexion").length;
onready var cam =get_node("/root/level/Player/Camera2")

var control_wait =0
var prior_mouse_pos = Vector2(0,0)

func _physics_process(delta):
	
	var mouse_pos =	get_viewport().get_mouse_position()
	if mouse_pos.distance_squared_to(prior_mouse_pos) >= 25:
		prior_mouse_pos = mouse_pos
		control_wait = 2 #indicates we need to deal with the mouse
	if control_wait == 0 || control_wait == 2:
		ray_origin = cam.project_ray_origin(mouse_pos)
		ray_target = cam.project_ray_normal(mouse_pos)*100000
		
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
		
				
			if($AnimationPlayer4.is_playing()):
				return
				
			#for the "aim" animation, -PI/2 is "top" - corresponds to length in secs
			#PI/2 is "bottom" - corresponds to 0 seconds
			#hence this formula	
			var frame = max(0,(PI/2-angle)/PI)
			frame = min(frame,1.0)*armswing_length
			
			#now, seek to that frame of the "aim" animation
			$AnimationPlayer4.current_animation = "flexion"
			$AnimationPlayer4.seek(frame,true)
			$AnimationPlayer4.stop()
			
#			if control_wait <= 0.0:
			if(abs(angle) > PI/2.0 && facing == FACING_RIGHT):
				print_debug("CW")
				$AnimationPlayer3.play("cw001")
	#			animation.play("rotate_cw")
				facing = FACING_LEFT
				control_wait = 0
				
			elif(abs(angle) > PI/2.0 && facing == FACING_LEFT):
				print_debug("CCW")
				$AnimationPlayer2.play("ccw002")
	#			animation.play("rotate_ccw")
				facing = FACING_RIGHT
				control_wait = 0
		control_wait = 0 #reset
			
	if Input.is_action_pressed("ui_right"):
		if control_wait <= 1:
			vel.x=2*lerp(10,sp,0.125)
			#facing=FACING_RIGHT
			anim_player.play("walking")
			control_wait = 1
	elif Input.is_action_pressed("ui_left"):
		if control_wait <= 1:
			anim_player.play("walking")
			vel.x=2*lerp(-10,-sp,0.125)
			#facing=FACING_LEFT
			control_wait = 1
	
		
	elif Input.is_action_pressed("ui_right") and Input.is_action_pressed("ui_left"):
		vel.y=0
	else: vel.x=0
	if Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_down") and is_on_floor():
		vel.y=0
	elif Input.is_action_pressed("ui_up") and is_on_floor():
		accel = leg_force
		$AnimationPlayer5.play("jump")
	elif Input.is_action_pressed("ui_down") and is_on_floor():
		accel = -leg_force
	else:
		vel.y = lerp(vel.z,0,0.1)

	if get_translation_delta().y == 0:
		accel = 0
	accel += gravity*delta
	vel.y += accel
	physics_delta = delta
	
	var _ret = move_and_slide(vel*physics_delta, Vector3(0, 1, 0), false, 4, 0.785398, true)


func hurt():
	$Armature/Skeleton/Cylinder002.get_surface_material(3).set_albedo(Color(30,0,0))
	$colour_change.start()


func kill():
	kill_var=kill_var+1
	gun.super_power()
	return kill_var
	
func _ready():
	set_axis_lock(PhysicsServer.BODY_AXIS_LINEAR_Z,true)
	set_axis_lock(PhysicsServer.BODY_AXIS_ANGULAR_X,true)
	

	add_to_group("Player")
	
func get_translation_delta():
	var delta = last_trans - translation
	last_trans = translation
	return delta

func _process(_delta):
	$health_rotate.rotate_y(deg2rad(10))
	#IMHO, Player.hurt() should take a "damage" argument, and do the subtraction there, rather than anything calling Player.hurt()
	#for the moment, this will prevent health going below zero and failing to trip the "restart" and "health_regen" code
	health = max(0,health)
	match health:
			2:
				$health_rotate/health2.hide()
			1:
				$health_rotate/health2.hide()
				$health_rotate/health1.hide()
			0:
				GameData.restore("user://saves")
				var _ret = get_tree().reload_current_scene()
	#			knees.get_surface_material(0).set_albedo(Color(0, 1, 0))
	#			lknees.get_surface_material(0).set_albedo(Color(0, 1, 0))
	var slide_count = get_slide_count()
	for i in slide_count:
		var col = get_slide_collision(i)
		if(col.collider):
			var groups = col.collider.get_groups()
			
			if(groups.has("enemy")):
				#var _ret = get_tree().reload_current_scene()
				print("1: Player was hurt by touching an enemy!")


func _on_colour_change_timeout():
	#lknees.get_surface_material(0).set_albedo(Color(0, 1, 0))
	#knees.get_surface_material(0).set_albedo(Color(0, 1, 0))
	$Armature/Skeleton/Cylinder002.get_surface_material(3).set_albedo(Color(0,30,0))
	$colour_change.stop()

func _on_Area_health_regen():
	match health:
		2:$health_rotate/health1.show()
		3:$health_rotate/health2.show()

func _on_eyes_area_entered(area):
	if area.is_in_group("machine"):
		pass

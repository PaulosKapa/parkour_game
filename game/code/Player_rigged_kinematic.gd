extends KinematicBody


#pulled from prior player.gd

var vel= Vector3(0,0,0)
var gravity=-900
var jum= 500
var sp = 10000
const leg_force= 500
var accel = 0
var last_trans = translation
var physics_delta = 0;
var kill=0
var dbjump=0
var health=3
var cant_dash=0

onready var internal = $fire_pose_playerrig
onready var gun = $w

# Called when the node enters the scene tree for the first time.
func _ready():
	set_axis_lock(PhysicsServer.BODY_AXIS_LINEAR_Z,true)
	set_axis_lock(PhysicsServer.BODY_AXIS_ANGULAR_X,true)
	

	add_to_group("Player")

func hurt():
	print("Player_Rigged:hurt")
	#knees.get_surface_material(0).set_albedo(Color(1, 0, 0))
	#lknees.get_surface_material(0).set_albedo(Color(1, 0, 0))
	$colour_change.start()
	
func kill():
	kill=kill+1
	gun.super_power()
	return kill
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$health_rotate.rotate_y(deg2rad(10))
	match health:
			2:$health_rotate/health2.hide()
			1:[$health_rotate/health2.hide(), $health_rotate/health.hide()]
			#using hide() instead of queue_free(), so they reappear if we add health regen
			0:[GameData.restore("user://saves"),get_tree().reload_current_scene()]
			#todo: place these back in the 0 case
			#knees.get_surface_material(0).set_albedo(Color(0, 1, 0)), 	lknees.get_surface_material(0).set_albedo(Color(0, 1, 0))

	position_gun()
	pass

func position_gun():
	if !gun:
		print("fail")
	if !internal:
		print("fail")
		
	var rads = internal.aim_angle
	var point = (internal.trigger_point())
	if !point:
		return
	var base = global_transform.origin;
	base+=Vector3(point.x,point.y-0.45,0)
	gun.global_transform.origin = base
	var orientation = gun.rotation
	if internal.facing == internal.FACING_RIGHT:
		orientation.y = PI*1.5
	else:
		orientation.y = PI*0.5
	#it's the x axis because the gun was rotated 90 degreesfrom its default position
	orientation.x = rads
	gun.rotation = orientation

func get_translation_delta():
	var delta = last_trans - translation
	last_trans = translation
	return delta
	
func _physics_process(delta):
	var anim = $fire_pose_playerrig/AnimationPlayer

	if Input.is_action_pressed("ui_right"):
		vel.x=lerp(10,sp,0.125)
		internal.face_right()
		anim.play("modelswalk")
		#collision_anim.play("col_walk")
		#$playernop/s1/walk.play("walk")
		#$animation.play("walking_col")
	elif Input.is_action_pressed("ui_left"):
		
		#$animation.play("walking_col")
		#$playernop/s1/walk.play("walk")
		
		#collision_anim.play("col_walk")
		anim.play("modelswalk")
		vel.x=lerp(-10,-sp,0.125)
		internal.face_left()
		
	elif Input.is_action_pressed("ui_right") and Input.is_action_pressed("ui_left"):
		vel.y=0
	else: vel.x=0
	if Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_down") and is_on_floor():
		vel.y=0
	elif Input.is_action_pressed("ui_up") and is_on_floor():
		accel = leg_force
		$doublejump.start()
		dbjump=1
	elif Input.is_action_just_pressed("ui_up") and dbjump==1:
		accel=leg_force
		dbjump=0
	elif Input.is_action_pressed("ui_down") and is_on_floor():
		accel = -leg_force
	else:
		vel.y = lerp(vel.z,0,0.1)
	if Input.is_action_just_pressed("ctrl"):
		Engine.time_scale = 0.5
		$Timer.start()
	
	if Input.is_action_just_pressed("dash") and cant_dash==0:
		match internal.facing:
			internal.FACING_RIGHT:vel.x=sp*2
			internal.FACING_LEFT:vel.x=-sp*2
		cant_dash=1
		$doublejump.start()
	if get_translation_delta().y == 0:
		accel = 0
	accel += gravity*delta
	vel.y += accel
	physics_delta = delta
	move_and_slide(vel*physics_delta, Vector3(0, 1, 0), false, 4, 0.785398, true)


func _on_Timer_timeout():
	Engine.time_scale = 1
	$Timer.stop()


func _on_doublejump_timeout():
	cant_dash=0
	$doublejump.stop()
	
func _on_colour_change_timeout():
	#lknees.get_surface_material(0).set_albedo(Color(0, 1, 0))
	#knees.get_surface_material(0).set_albedo(Color(0, 1, 0))
	$colour_change.stop()
	
func _on_Area_health_regen():
	match health:
		2:$health_rotate/health.show()
		3:$health_rotate/health2.show()

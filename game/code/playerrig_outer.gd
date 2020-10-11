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
var dbjump=0
var health=3
enum {FACING_LEFT, FACING_RIGHT}
var facing = FACING_LEFT
var cant_dash=0
onready var gun = get_node("/root/level/Player/fire_pose_playerrig/w")
onready var anim_player = get_node("/root/level/Player/fire_pose_playerrig/AnimationPlayer")
var _collisions = []
onready var knees = get_node("/root/level/Player/playernop/torso/rhip/rknee")
onready var lknees = get_node("/root/level/Player/playernop/torso/lhip/lknee")

func hurt():
	#knees.get_surface_material(0).set_albedo(Color(1, 0, 0))
	#lknees.get_surface_material(0).set_albedo(Color(1, 0, 0))
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
	match health:
			2:
				$health_rotate/health2.hide()
			1:
				$health_rotate/health2.hide()
				$health_rotate/health.hide()
			#using hide() instead of queue_free(), so they reappear if we add health regen
			0:
				GameData.restore("user://saves")
				#var _ret = get_tree().reload_current_scene()
				knees.get_surface_material(0).set_albedo(Color(0, 1, 0))
				lknees.get_surface_material(0).set_albedo(Color(0, 1, 0))
	var slide_count = get_slide_count()
	for i in slide_count:
		var col = get_slide_collision(i)
		if(col.collider):
			var groups = col.collider.get_groups()
			
			if(groups.has("enemy")):
				#var _ret = get_tree().reload_current_scene()
				print("1: Player was hurt by touching an enemy!")

func _physics_process(delta):
	if Input.is_action_pressed("ui_right"):
		vel.x=lerp(10,sp,0.125)
		facing=FACING_RIGHT
		anim_player.play("modelswalk")
	elif Input.is_action_pressed("ui_left"):
		anim_player.play("modelswalk")
		vel.x=lerp(-10,-sp,0.125)
		facing=FACING_LEFT
		
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
		match facing:
			FACING_RIGHT:vel.x=sp*2
			FACING_LEFT:vel.x=-sp*2
		cant_dash=1
		$doublejump.start()
	if get_translation_delta().y == 0:
		accel = 0
	accel += gravity*delta
	vel.y += accel
	physics_delta = delta
	#var _ret = move_and_collide(vel*0,false)
	var _ret = move_and_slide(vel*physics_delta, Vector3(0, 1, 0), false, 1, 0.785398, true)
	print(global_transform.origin)

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

extends KinematicBody
#i ve added some testing features, for a 3d perspective.
var vel= Vector3(0,0,0)
var gravity=-900
var jum= 500
var sp = 3000
const leg_force= 550
var accel = 0
var last_trans = translation
var physics_delta = 0;
var kill_var=0
var health=3
enum {FACING_LEFT, FACING_RIGHT}
var facing = FACING_LEFT
var cant_dash=0
onready var gun = $new1/Armature/Skeleton/gun_holder/w
onready var anim_player = $new1/AnimationPlayer5
onready var pistol_holder = $new1/AnimationPlayer3
var _collisions = []
export (NodePath) var camio
var ray_origin = Vector3()
var ray_target=Vector3()
onready var cam =get_node("/root/level/Player/Camera2")

var control_wait =0
var prior_mouse_pos = Vector2(0,0)

func _physics_process(delta):
	
	anim_player.stop(false)
	if Input.is_action_pressed("ui_right"):
		if control_wait <= 1:
			vel.z=2*lerp(10,sp,0.125)
			anim_player.play("walking")
			control_wait = 1
	elif Input.is_action_pressed("ui_left"):
		if control_wait <= 1:
			anim_player.play("walking")
			vel.z=2*lerp(-10,-sp,0.125)
			control_wait = 1
	elif Input.is_action_pressed("ui_rvs"):
		if control_wait <= 1:
			anim_player.play("walking")
			vel.x=2*lerp(-10,-sp,0.125)
			control_wait = 1
			
	elif Input.is_action_pressed("ui_fwd"):
		if control_wait <= 1:
			anim_player.play("walking")
			vel.x=2*lerp(10,sp,0.125)
			control_wait = 1
	
		
	elif Input.is_action_pressed("ui_right") and Input.is_action_pressed("ui_left"):
		#vel.y=0
		vel.z=0
	elif Input.is_action_pressed("ui_fwd") and Input.is_action_pressed("ui_rvs"):
		#vel.y=0
		vel.x=0
	elif Input.is_action_just_released("ui_fwd") or Input.is_action_just_released("ui_rvs"):
		#vel.y=0
		vel.x=0
	elif Input.is_action_just_released("ui_left") or Input.is_action_just_released("ui_right"):
		#vel.y=0
		vel.z=0
	#if Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_down"):
		#vel.y=0
	if Input.is_action_pressed("ui_up") and is_on_floor():
		accel = leg_force
		$new1/AnimationPlayer1.play("jump")
	#elif Input.is_action_pressed("ui_down") and is_on_floor():
	#	accel = -leg_force
	#if Input.is_action_pressed("ui_fwd") or Input.is_action_pressed("ui_rvs"):
		#vel.y = lerp(0,1,0.1)
		
	#elif Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left"):
		#vel.z = lerp(0,1,0.1)

	#if get_translation_delta().y == 0 or get_translation_delta().z==0:
		#accel = 0
	accel += gravity*delta
	vel.y += accel
	physics_delta = delta

	var _ret = move_and_slide(vel*physics_delta, Vector3(0, 1, 0), false, 4, 0.785398, true)


func hurt():
	$new1/Armature/Skeleton/Cube.get_surface_material(2).set_albedo(Color(30,0,0))
	$colour_change.start()


func kill():
	kill_var=kill_var+1
	gun.super_power()
	return kill_var
	
func _ready():
	set_axis_lock(PhysicsServer.BODY_AXIS_LINEAR_Z,true)
	set_axis_lock(PhysicsServer.BODY_AXIS_ANGULAR_X,true)
	pistol_holder.play("pistol_holster")

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
				$new1/Armature/Skeleton/Cube.get_surface_material(2).set_albedo(Color(0,30,0))
				
	var slide_count = get_slide_count()
	for i in slide_count:
		var col = get_slide_collision(i)
		if(col.collider):
			var groups = col.collider.get_groups()
			
			if(groups.has("enemy")):
				#var _ret = get_tree().reload_current_scene()
				print("1: Player was hurt by touching an enemy!")


func _on_colour_change_timeout():
	$new1/Armature/Skeleton/Cube.get_surface_material(2).set_albedo(Color(0,30,0))
	$colour_change.stop()

func _on_Area_health_regen():
	match health:
		2:$health_rotate/health1.show()
		3:$health_rotate/health2.show()

func _on_eyes_area_entered(area):
	if area.is_in_group("machine"):
		pass

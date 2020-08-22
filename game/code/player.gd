extends RigidBody
enum {CMD_NONE,
	CMD_LEFT,
	CMD_RIGHT,
	CMD_UP,
	CMD_DOWN,
	CMD_CANCEL_LEFTRIGHT,
	CMD_CANCEL_UPDOWN}
var command = CMD_NONE
var right_accel=Vector3(7.5*8,0,0)
export(float) var jump_strength = 5.44*27
var jump_accel=Vector3(0,jump_strength,0) 

onready var camera = get_node("/root/level/InterpolatedCamera")

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
enum {FACING_LEFT, FACING_RIGHT}
var facing = FACING_LEFT
var cant_dash=0
onready var gun = get_node("/root/level/Player/Spatial3/Spatial2")

var _thrown = false #Did the Player just get thrown by an explosion?

func kill():
	kill=kill+1
	gun.super_power()
	return kill
	

func _ready():
	add_to_group("Player")
	
func get_translation_delta():
	var delta = last_trans - translation
	last_trans = translation
	return delta


func _physics_process(delta):

	#The three "New Anim"s seem to be missing from the node named "s"
	#hence the references are commented out for now (FLJ, 21 Aug 2020)
#	if Input.is_action_pressed("ui_left") and Input.is_action_just_pressed("transport") and is_on_floor():
#			$s/animation.play("New Anim")
#	elif Input.is_action_pressed("ui_right")and Input.is_action_just_pressed("transport") and is_on_floor():
#			$s/animation.play("New Anim (3)")
#	elif Input.is_action_just_released("transport"):
#		$s/animation.play("New Anim (2)")

#The input results are handled outside of the physics part of the loop
	if Input.is_action_pressed("ui_right"):
		command = CMD_RIGHT 
	elif Input.is_action_pressed("ui_left"):
		command = CMD_LEFT 
		
	elif Input.is_action_pressed("ui_right") and Input.is_action_pressed("ui_left"):
		command = CMD_CANCEL_UPDOWN
	else: command = CMD_CANCEL_LEFTRIGHT

	if Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_down") and is_on_floor():
		command = CMD_CANCEL_UPDOWN
	elif Input.is_action_pressed("ui_up") and is_on_floor():
		command = CMD_UP
		$doublejump.start()
		dbjump=1
	elif Input.is_action_just_pressed("ui_up") and dbjump==1:
		print("JUMP", dbjump)
		command = CMD_UP
		dbjump=0
	elif Input.is_action_pressed("ui_down") and is_on_floor():
		command = CMD_DOWN

	if Input.is_action_just_pressed("ctrl"):
		Engine.time_scale = 0.5
		$Timer.start()
		
	if Input.is_action_just_pressed("dash") and cant_dash==0:
		cant_dash=1
		$doublejump.start()
	
	
func _process(delta):
		#As of 21 Aug 2020, nothing causes _thrown to be set to true
		#Otherwise, this would leave the user unable to change direction until the Player 
		#hits the ground after being thrown by an explosion
		if _thrown:
			return
		match command:
		#we double the accel if cant_dash is 1 , no multiplication if cant_dash is 0
			CMD_LEFT:
				add_central_force(-right_accel*(1+cant_dash))
			CMD_RIGHT:
				add_central_force(right_accel*(1+cant_dash))
			CMD_CANCEL_LEFTRIGHT:
				#Calculate the force needed for a near-immediate stop
				#(s2-s1)/t = d
				#s2 is 0, so -s1/t = d
				#t can't be 0, so use a frame's duration
				var decelx = -.5*linear_velocity.x/delta
				#and since force = mass * acceleration
				add_central_force(Vector3(decelx*mass,0,0))
			CMD_CANCEL_UPDOWN:
				#Calculate the force needed to cancel a jump 
				var decely = -.5*linear_velocity.x/delta
				add_central_force(Vector3(0,decely*mass,0))
			CMD_UP:
				add_central_force(jump_accel)
			CMD_DOWN:
				add_central_force(-jump_accel)
		command = CMD_NONE

func _on_Timer_timeout():
	Engine.time_scale = 1
	$Timer.stop()

#this function doesn't exist natively in RigidBody, but the logic orignally used for a KinematicBody
#needs it
#If the vertical movement has essentially stopped, we must be on a floor
func is_on_floor():
	return abs(linear_velocity.y) < 0.1

#This is here in anticipation of our being aware of being thrown by an explosion	
func _check_for_post_boom_landing(delta):
	if is_on_floor():
		_thrown=false
	return
	
func _on_doublejump_timeout():
	cant_dash=0
	$doublejump.stop()

		

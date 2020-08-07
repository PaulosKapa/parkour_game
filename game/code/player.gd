extends KinematicBody
var vel= Vector3(0,0,0)
var gravity=-900
var jum= 500
var sp = 10000
const leg_force= 500
var accel = 0
var last_trans = translation
var physics_delta = 0;
var kill=0
onready var gun_timer = get_node("/root/level/Player/Spatial3/Spatial2/Timer")
onready var gun = get_node("/root/level/Player/Spatial3/Spatial2")

func kill():
	kill=kill+1
	gun.bullets_left=gun.bullets_left+kill*2
	super_power()
	return kill
	
func super_power():
	if kill==1:
		gun_timer.wait_time=0.1
		$superpower.start()
		print("right")

func _ready():
	add_to_group("Player")
func get_translation_delta():
	var delta = last_trans - translation
	last_trans = translation
	return delta


func _physics_process(delta):

	if Input.is_action_pressed("ui_left") and Input.is_action_just_pressed("transport") and is_on_floor():
			$s/animation.play("New Anim")
	elif Input.is_action_pressed("ui_right")and Input.is_action_just_pressed("transport") and is_on_floor():
			$s/animation.play("New Anim (3)")
	elif Input.is_action_just_released("transport"):
		$s/animation.play("New Anim (2)")
	if Input.is_action_pressed("ui_right"):
		vel.x=lerp(10,sp,0.125)
	elif Input.is_action_pressed("ui_left"):
		vel.x=lerp(-10,-sp,0.125)
		
	elif Input.is_action_pressed("ui_right") and Input.is_action_pressed("ui_left"):
		vel.y=0
	else: vel.x=0
	if Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_down") and is_on_floor():
		vel.y=0
	elif Input.is_action_pressed("ui_up") and is_on_floor():
		accel = leg_force
	elif Input.is_action_pressed("ui_down") and is_on_floor():
		accel = -leg_force
	else:
		vel.y = lerp(vel.z,0,0.1)
	if Input.is_action_just_pressed("ctrl"):
		Engine.time_scale = 0.5
		$Timer.start()
	
	if get_translation_delta().y == 0:
		accel = 0
	accel += gravity*delta
	vel.y += accel
	physics_delta = delta
	move_and_slide(vel*physics_delta, Vector3(0, 1, 0), false, 4, 0.785398, true)
	

func _on_Timer_timeout():
	Engine.time_scale = 1
	$Timer.stop()


func _on_superpower_timeout():
	print(123)
	gun_timer.wait_time=1
	$superpower.stop()

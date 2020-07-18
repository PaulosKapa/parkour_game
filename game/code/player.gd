extends KinematicBody
var vel= Vector3(0,0,0)
var gravity=-900
var jum= 500
var sp = 10000
const leg_force= 500
var accel = 0
var last_trans = translation
var physics_delta = 0;
func get_translation_delta():
	var delta = last_trans - translation
	last_trans = translation
	return delta


func _physics_process(delta):
	if Input.is_action_pressed("ui_right"):
		vel.x=lerp(vel.z,sp,0.125)
	elif Input.is_action_pressed("ui_left"):
		vel.x=lerp(vel.z,-sp,0.125)
	
	elif Input.is_action_pressed("ui_right") and Input.is_action_pressed("ui_left"):
		vel.y=0
	else: vel.x=0
	if Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_down") and is_on_floor():
		vel.y=0
	elif Input.is_action_pressed("ui_up") and is_on_floor():
		accel = leg_force
	else:
		vel.y = lerp(vel.z,0,0.1)
	
	if get_translation_delta().y == 0:
		accel = 0
	accel += gravity*delta
	vel.y += accel
	physics_delta = delta
	move_and_slide(vel*physics_delta, Vector3(0, 1, 0), false, 4, 0.785398, true)
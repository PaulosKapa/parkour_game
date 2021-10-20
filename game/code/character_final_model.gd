extends KinematicBody
#i ve added some testing features, for a 3d perspective.
var vel= Vector3(0,0,0)
var jum= 500
const leg_force= 550
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
onready var cam =get_node("/root/level/Player/Head/Camera2")
var control_wait =0
var speed = 7
const ACCEL_DEFAULT = 7
const ACCEL_AIR = 1
onready var accel = ACCEL_DEFAULT
var gravity = 9.8
var jump = 5

var cam_accel = 40
var mouse_sense = 0.1
var snap

var direction = Vector3()
var velocity = Vector3()
var gravity_vec = Vector3()
var movement = Vector3()

onready var head = $Head
onready var camera = $Head/Camera

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pistol_holder.play("pistol_holster")
	add_to_group("Player")
	

func _input(event):
	if event is InputEventMouseMotion:
		
		head.rotate_x(deg2rad(-event.relative.y * mouse_sense))
		head.rotation.x = clamp(head.rotation.x, deg2rad(-89), deg2rad(89))


func _physics_process(delta):
	direction = Vector3.ZERO
	var h_rot = global_transform.basis.get_euler().y
	var f_input = Input.get_action_strength("ui_rvs") - Input.get_action_strength("ui_fwd")
	var h_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direction = Vector3(h_input, 0, f_input).rotated(Vector3.UP, h_rot).normalized()
	
	if is_on_floor():
		snap = -get_floor_normal()
		accel = ACCEL_DEFAULT
		gravity_vec = Vector3.ZERO
	else:
		snap = Vector3.DOWN
		accel = ACCEL_AIR
		gravity_vec += Vector3.DOWN * gravity * delta
		
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		snap = Vector3.ZERO
		gravity_vec = Vector3.UP * jump
	
	velocity = velocity.linear_interpolate(direction * speed, accel * delta)
	movement = velocity + gravity_vec
	
	move_and_slide_with_snap(movement, snap, Vector3.UP)
	anim_player.stop(false)
	if Input.is_action_pressed("ui_right"):
		if control_wait <= 1:
			anim_player.play("walking")
			control_wait = 1
	elif Input.is_action_pressed("ui_left"):
		if control_wait <= 1:
			anim_player.play("walking")
			control_wait = 1
	elif Input.is_action_pressed("ui_rvs"):
		if control_wait <= 1:
			anim_player.play("walking")
			control_wait = 1
			
	elif Input.is_action_pressed("ui_fwd"):
		if control_wait <= 1:
			anim_player.play("walking")
			control_wait = 1
	


func hurt():
	$new1/Armature/Skeleton/Cube.get_surface_material(2).set_albedo(Color(30,0,0))
	$colour_change.start()


func kill():
	kill_var=kill_var+1
	gun.super_power()
	return kill_var
	


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

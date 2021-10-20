extends KinematicBody
var health = 3
var speed = 10
var h_acceleration = 6
var air_acceleration = 1
var normal_acceleration = 6
var gravity = 20
var jump = 10
var full_contact = false
var mouse_sensitivity = 0.03
var direction = Vector3()
var h_velocity = Vector3()
var movement = Vector3()
var gravity_vec = Vector3()
onready var anim_player = $new1/AnimationPlayer5
onready var jump_anim = $new1/AnimationPlayer1
onready var head = $Head
onready var ground_check = $groundcheck

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		head.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
		head.rotation.x = clamp(head.rotation.x, deg2rad(-70), deg2rad(89))
		
func _physics_process(delta):
	
	direction = Vector3()
	
	full_contact = ground_check.is_colliding()
	
	if not is_on_floor():
		gravity_vec += Vector3.DOWN * gravity * delta
		h_acceleration = air_acceleration
	elif is_on_floor() and full_contact:
		gravity_vec = -get_floor_normal() * gravity
		h_acceleration = normal_acceleration
	else:
		gravity_vec = -get_floor_normal()
		h_acceleration = normal_acceleration
		
	if Input.is_action_just_pressed("ui_up") and (is_on_floor() or ground_check.is_colliding()):
#		jump_anim.play("jump")
		gravity_vec = Vector3.UP * jump
	
	if Input.is_action_pressed("ui_fwd"):
		direction -= transform.basis.z
	#	anim_player.play("walking")
	elif Input.is_action_pressed("ui_rvs"):
		direction += transform.basis.z
	#	anim_player.play("walking")
	if Input.is_action_pressed("ui_left"):
		direction -= transform.basis.x
		#anim_player.play("walking")
	elif Input.is_action_pressed("ui_right"):
		direction += transform.basis.x
	#	anim_player.play("walking")
	
	direction = direction.normalized()
	h_velocity = h_velocity.linear_interpolate(direction * speed, h_acceleration * delta)
	movement.z = h_velocity.z + gravity_vec.z
	movement.x = h_velocity.x + gravity_vec.x
	movement.y = gravity_vec.y
	
	move_and_slide(movement, Vector3.UP)
	
func _process(delta):
	$health_rotate.rotate_y(deg2rad(1))
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


extends Spatial
onready var Parent = get_parent()
onready var cursor = get_node("/root/level/cursor_game/Viewport/cursor_game/AnimationPlayer")
onready var Camera = get_node("/root/level/Player/Head/Camera2")
onready var Bullet= preload("res://scenes/bullet.tscn")
onready var mouse_position = Vector3(0,0,0)
onready var kil = get_node("/root/level/Player")
var bullet_spawn_location = Vector3(0,0,0)
var cant_shoot_var = 0
var bullets_left=9

func super_power():
	if kil.kill_var==1:
		$superpower.start()
		$Timer.wait_time=0.1

func cant_shoot():
	cant_shoot_var=1
	return cant_shoot_var

func reload():
	if cant_shoot_var == 1:
		$reload.start()
		$reload2.play()
		$AnimationPlayer.play("pistol_reload")

func _process(_delta):
	match cant_shoot_var:
		1:
			$pistol_1/Sphere009.get_surface_material(0).set_albedo(Color(1,0,0))
		0:
			$pistol_1/Sphere009.get_surface_material(0).set_albedo(Color(0,1,0))
	if Input.is_action_pressed("click"):
		mouse_position = get_tree().root.get_mouse_position()
		shoot()
		
func shoot():
	if cant_shoot_var==0 and bullets_left>0:
		cursor.play("cursor")
		print(bullets_left)
		$ammo.scale_object_local(Vector3(1,0.8,1))
		$Particles.set_emitting(true)
		$fire.play(true)
		#we need the angle at which the player's pistol is turned, relative to its own (0,0,1)
		#and to convert that to a unit vector for the direction of the shot
		$AnimationPlayer.play("πιστολ_1_σηοοτ")
		var gun_global_rotation = global_transform.basis.get_rotation_quat().get_euler()
		#we want the gun's rotation about the z-axis
		var bullet_translation_vector = Vector3(cos(gun_global_rotation),sin(gun_global_rotation),0)
		#nice for the left, so deal with the right
		if kil.facing == kil.FACING_RIGHT:
			bullet_translation_vector.x = -bullet_translation_vector.x
		#now that we have the bullet's direction, add the bullet to the Scene and get it moving
		var bullet = Bullet.instance()
		get_node("/root/level").add_child(bullet)
		var pos = Camera.unproject_position(Parent.global_transform.origin)
		bullet.set_speed(bullet_translation_vector)
		bullet.global_transform.origin = global_transform.origin
		bullets_left=bullets_left-1
		cant_shoot()
		$Timer.start()


	elif cant_shoot_var == 0 and bullets_left<=0:
		cant_shoot()
		reload()
	

func _on_Timer_timeout():
	cant_shoot_var=0
	$Timer.stop()

func _on_reload_timeout():
	bullets_left=9
	cant_shoot_var=0
	$ammo.scale_object_local(Vector3(1,7.5,1))
	$reload.stop()

func _on_superpower_timeout():
	kil.kill_var=0
	$Timer.wait_time=1
	$superpower.stop()

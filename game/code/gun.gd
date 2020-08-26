extends Spatial
onready var Parent = get_parent()
onready var Camera = get_node("/root/level/InterpolatedCamera")
onready var Bullet= preload("res://scenes/bullet.tscn")
onready var mouse_position = Vector3(0,0,0)
onready var kil = get_node("/root/level/Player")
var bullet_spawn_location = Vector3(0,0,0)
var cant_shoot = 0
var bullets_left=9

func super_power():
	if kil.kill==1:
		$superpower.start()
		bullets_left=bullets_left+kil.kill*2
		$Timer.wait_time=0.1


func cant_shoot():
	cant_shoot=1
	return cant_shoot
	
func _process(delta):
	if Input.is_action_pressed("click"):
		mouse_position = get_tree().root.get_mouse_position()
		shoot()
		
func shoot():
	if bullets_left<=0:
			$reload.start()
			cant_shoot()
	elif cant_shoot==0:
		print(bullets_left)
		var bullet = Bullet.instance()
		get_node("/root/level").add_child(bullet)
		var pos = Camera.unproject_position(Parent.global_transform.origin)
		var bullet_translation_vector = global_transform.origin
	
		var bs_vc = mouse_position - pos
		var bullet_speed_vector = Vector3(bs_vc.x, bs_vc.y, 0)
		bullet_speed_vector.y *= -1
	
		bullet.global_rotate(Vector3(1, 0, 0), 300)
		bullet.set_speed(bullet_speed_vector.normalized())
		bullet.global_transform.origin = bullet_translation_vector
		bullets_left=bullets_left-1
		$Timer.start()
		cant_shoot()

func _on_Timer_timeout():
	cant_shoot=0
	$Timer.stop()


func _on_reload_timeout():
	
	bullets_left=9
	cant_shoot=0
	print(bullets_left)
	$reload.stop()


func _on_superpower_timeout():
	print(123)
	kil.kill=0
	$Timer.wait_time=1
	$superpower.stop()

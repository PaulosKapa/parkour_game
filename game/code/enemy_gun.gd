extends Spatial
onready var Parent = get_parent().get_parent().get_parent()
onready var Camera = get_node("/root/level/Player/InterpolatedCamera")
onready var Bullet= preload("res://scenes/bullet.tscn")
onready var laser_sound = get_node("/root/level/Spatial4/StaticBody/sentry/pivot_point_sentry/gun/laser")
onready var mouse_position = Vector3(0,0,0)
var bullet_spawn_location = Vector3(0,0,0)
var cant_shoot_var=0

func cant_shoot():
	cant_shoot_var=1
	return cant_shoot_var
	
func shoot(target):
	if cant_shoot_var==0:
		var bullet = Bullet.instance()
		get_node("/root/level").add_child(bullet)
		laser_sound.play()
	
		var spat = get_node("/root/level/Spatial4/StaticBody/sentry/pivot_point_sentry/gun")
		var spatial_pos=spat.global_transform.origin
		bullet_spawn_location = Vector3(spatial_pos.x,spatial_pos.y, 0)
	
		var _apos = Camera.unproject_position(global_transform.origin)
		var bullet_translation_vector = Vector3(global_transform.origin.x +2,global_transform.origin.y, global_transform.origin.z)
	
		var bullet_speed_vector = target.global_transform.origin - global_transform.origin;
	
	
		bullet.global_rotate(Vector3(1, 0, 0), 300)
		bullet.set_speed(bullet_speed_vector.normalized())
		bullet.global_translate(bullet_translation_vector)
		#more reliable "absolute positioning"
		bullet.global_transform.origin = bullet_spawn_location
		
		$Timer.start()
		
		cant_shoot()
		

func _on_Timer_timeout():
	cant_shoot_var=0
	$Timer.stop()

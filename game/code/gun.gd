extends Spatial
onready var Parent = get_node("/root/level")
onready var Camera = get_node("/root/level/InterpolatedCamera")
onready var Bullet= preload("res://scenes/bullet.tscn")
onready var mouse_position = Vector3(0,0,0)
var bullet_spawn_location = Vector3(0,0,0)

func _process(delta):
	if Input.is_action_just_pressed("click"):
		var mouse_pos = get_tree().root.get_mouse_position()
		mouse_position = mouse_pos
		shoot()
		
func shoot():
	var bullet = Bullet.instance()
	Parent.add_child(bullet)
	var pos = Camera.unproject_position(global_transform.origin)
	var bullet_translation_vector = Vector3(global_transform.origin.x +0.2,global_transform.origin.y, global_transform.origin.z)
	
	var bs_vc = mouse_position - pos
	var bullet_speed_vector = Vector3(bs_vc.x, bs_vc.y, 0)
	bullet_speed_vector.y *= -1
	
	bullet.global_rotate(Vector3(1, 0, 0), 300)
	bullet.set_speed(bullet_speed_vector.normalized())
	bullet.global_transform.origin = bullet_translation_vector
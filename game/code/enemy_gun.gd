extends Spatial
onready var Parent = get_parent().get_parent().get_parent()
onready var Camera = get_node("/root/level/InterpolatedCamera")
onready var Bullet= preload("res://scenes/bullet.tscn")
onready var mouse_position = Vector3(0,0,0)
var bullet_spawn_location = Vector3(0,0,0)

func shoot():
	var bullet = Bullet.instance()
	Parent.add_child(bullet)
	
	var spat = get_node("/root/level/Spatial/StaticBody/Spatial")
	var spatial_pos=spat.global_transform.origin
	bullet_spawn_location = Vector3(spatial_pos.x,spatial_pos.y, 0)
	
	var pos = Camera.unproject_position(global_transform.origin)
	var bullet_translation_vector = Vector3(global_transform.origin.x +2,global_transform.origin.y, global_transform.origin.z)
	
	var bullet_speed_vector = Vector3(1, 0, 0);
	
	bullet.global_rotate(Vector3(1, 0, 0), 300)
	bullet.set_speed(bullet_speed_vector.normalized())
	bullet.global_translate(bullet_translation_vector)

extends StaticBody
onready var Player = get_parent().get_node("Player")
onready var Parent = get_node("/root/level")
onready var Bullet= preload("res://scenes/bullet.tscn")
onready var Camera = get_node("/root/level/InterpolatedCamera")
onready var mouse_position = Vector3(0,0,0)
var bullet_spawn_location = Vector3(0,0,0)
var space_state
var target
var pos = Vector3(0, 0, 0)
var last_trans = translation
var physics_delta = 0;

func _ready():
	space_state = get_world().direct_space_state
	pos = global_transform.origin
	add_to_group("enemy")
	if target:
		var result = space_state.intersect_ray(global_transform.origin, target.global_transform.origin)
		if result.collider:
			if result.collider.is_in_group("Player"):
					var bullet = Bullet.instance()
					Parent.add_child(bullet)
					var opos = Camera.unproject_position(global_transform.origin)
					var bullet_translation_vector = Vector3(global_transform.origin.x +0.2,global_transform.origin.y, global_transform.origin.z)
					
					var bs_vc = mouse_position - opos
					var bullet_speed_vector = Vector3(bs_vc.x, bs_vc.y, 0)
					bullet_speed_vector.y *= -1
					
					bullet.global_rotate(Vector3(1, 0, 0), 300)
					bullet.set_speed(bullet_speed_vector.normalized())
					bullet.global_transform.origin = bullet_translation_vector
		
		else:
			pass
func _on_Area_body_entered(body):
	if body.is_in_group("Player"):
		target= body
		print(1)


func _on_Area_body_exited(body):
	if body.is_in_group("Player"):
		target= null
		print(2)





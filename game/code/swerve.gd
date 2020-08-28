extends Spatial

var ray_origin = Vector3()
var ray_target=Vector3()

onready var Camera = get_node("/root/level/InterpolatedCamera")

func _physics_process(delta):
	var mouse_position = get_tree().root.get_mouse_position()
	var pos = Camera.unproject_position(global_transform.origin)
	var rotation_vector = mouse_position - pos
	
	var angle = rotation_vector.angle_to(Vector2(-1, 0))
	self.set_rotation(Vector3(0,0, angle))

extends KinematicBody
export var speed = 2
onready var kil = get_node("/root/level/Player")
var space_state
var vel = Vector3(0,0,0)
var target
var gravity=100
var dir = 1
var physics_delta = 0;
var last_trans = translation

func get_translation_delta():
	var delta = last_trans - translation
	last_trans = translation
	return delta

func die():
	kil.kill()
	queue_free()

func _ready():
	space_state = get_world().direct_space_state
	add_to_group("enemy")

func _process(delta):
	if target:
		var result = space_state.intersect_ray(global_transform.origin, target.global_transform.origin)
		if result.collider.is_in_group("Player"):
			$"..".look_at(target.global_transform.origin, Vector3.UP)
			move_to_target(delta)

func move_to_target(delta):
	var direction = (target.global_transform.origin - global_transform.origin).normalized()
	vel = move_and_slide(direction * speed)

func _on_Area_body_entered(body):
		if body.is_in_group("Player"):
			target = body

func _on_Area_body_exited(body):
		if body.is_in_group("Player"):
			target = null

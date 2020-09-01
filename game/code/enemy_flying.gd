extends KinematicBody
export var speed = 10
onready var kil = get_node("/root/level/Player")
var space_state
var vel = Vector3(0,0,0)
var target
var gravity=100
var dir = 1
var physics_delta = 0;
var last_trans = translation
signal change_colour
var health=2

func get_translation_delta():
	var delta = last_trans - translation
	last_trans = translation
	return delta

func die(damage):
	health=health-damage
	if health==0:
		kil.kill()
		queue_free()

func _ready():
	space_state = get_world().direct_space_state
	add_to_group("enemy")

func _process(delta):
	if target:
		$"..".look_at(target.global_transform.origin, Vector3.UP)
		move_to_target(delta)

func move_to_target(delta):
	var direction = (target.global_transform.origin - global_transform.origin).normalized()
	vel = move_and_slide(direction * speed)
	
	var slide_count = get_slide_count()
	
	for i in slide_count:
		var col = get_slide_collision(i)
		if(col):
			var groups = col.collider.get_groups()
			if(groups.has("Player")):
				kil.health=kil.health-2
				emit_signal("change_colour")
				print("Player was hurt by touching an enemy!")
			queue_free()
			
func _on_Area_body_entered(body):
		if body.is_in_group("Player"):
			print (1)
			target = body

func _on_Area_body_exited(body):
		if body.is_in_group("Player"):
			print(2)
			target = null

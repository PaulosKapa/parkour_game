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
var health=2

func get_translation_delta():
	var delta = last_trans - translation
	last_trans = translation
	return delta

func die(damage):
	health=health-damage
	match health:
		1: $damaged.set_emitting(true)
			
		0:
			kil.kill()
			$enemy_flying.queue_free()
			$CollisionShape.queue_free()
			$explosion.set_emitting(true)
			$damaged.hide()
			$death.play()
			$end.start()

func _ready():
	$flying_sound.play()
	space_state = get_world().direct_space_state
	add_to_group("enemy")
func _physics_process(delta):
	if health>0:
		$enemy_flying/Icosphere001.rotate_y(rad2deg(1))
		$enemy_flying/Torus002.rotate_x(rad2deg(0.001))
		$enemy_flying/Cube.rotate_x(rad2deg(0.001))

func _process(delta):
	
	if target and health>0:
		$"..".look_at(target.global_transform.origin, Vector3.UP)
		move_to_target(delta)
func move_to_target(_delta):
	var direction = (target.global_transform.origin - global_transform.origin).normalized()
	vel = move_and_slide(direction * speed)
	
	var slide_count = get_slide_count()
	
	for i in slide_count:
		var col = get_slide_collision(i)
		if(col):
			var groups = col.collider.get_groups()
			if(groups.has("Player")):
				#col.collider.hurt()
				#kil.health=kil.health-2
				pass
func _on_Area_body_entered(body):
	if body.is_in_group("Player") and health>0:
		target = body

func _on_Area_body_exited(body):
	if body.is_in_group("Player"):
		target = null


func _on_end_timeout():
	queue_free()

extends KinematicBody

export var speed = 10
onready var kil = get_node("/root/level/Player")
var space_state
var vel = Vector3(0,0,0)
var target
var dir = 1
var physics_delta = 0;
var last_trans = translation
var alive = 1

func get_translation_delta():
	var delta = last_trans - translation
	last_trans = translation
	return delta

func die(damage):
	if alive == 1:
		$CollisionShape.queue_free()
		$fire.queue_free()
		$ROCKET.queue_free()
		$explode.play()
		$explosion.set_emitting(true)
		$death.start()
	
	alive = 0

func _ready():
	space_state = get_world().direct_space_state
	add_to_group("rocket")

func _process(delta):
	
	if target and alive ==1:
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
				die(1)
				#col.collider.hurt()
				#kil.health=kil.health-2
				pass
func _on_Area_body_entered(body):
	if body.is_in_group("Player"):
		target = body

func _on_Area_body_exited(body):
	if body.is_in_group("Player"):
		die(1)
		target = null


func _on_death_timeout():
	$death.stop()
	queue_free()

extends StaticBody
onready var Camera = get_node("/root/level/Player/InterpolatedCamera")
onready var Parent = get_parent()
var rocket = preload("res://scenes/rocket.tscn")
onready var kil = get_node("/root/level/Player")
var space_state
var target
var physics_delta = 0;
var last_trans = translation
var health=2
var cant_shoot = 0
var rock_spawn_location = Vector3(0,0,0)

func get_translation_delta():
	var delta = last_trans - translation
	last_trans = translation
	return delta

func die(damage):
	health=health-damage
	match health:
		1: pass
		0:
			$death_particles.set_emitting(true)
			$death.start()
			$rocket_launcher.queue_free()
			cant_shoot=1
			$CollisionShape.queue_free()
			$explode.play()

func _ready():
	space_state = get_world().direct_space_state
	add_to_group("enemy")

func _process(delta):
	if target and cant_shoot == 0:
		shoot()

func _on_Area_body_entered(body):
	if body.is_in_group("Player"):
		target = body

func _on_Area_body_exited(body):
	if body.is_in_group("Player"):
		target = null

func shoot():
	$firing.restart()
	$shoot_sound.play()
	$firing.set_emitting(true)
	var rock = rocket.instance()
	get_node("/root/level").add_child(rock)
	var spat = $shoot_point
	var spatial_pos=spat.global_transform.origin
	rock_spawn_location = Vector3(spatial_pos.x,spatial_pos.y, spatial_pos.z)
	rock.global_transform.origin = rock_spawn_location
	rock.global_rotate(Vector3(0, 1, 0), 300)
	$shoot.start()
	cant_shoot = 1

func _on_shoot_timeout():
	cant_shoot = 0
	$shoot.stop()
	$firing.set_emitting(false)


func _on_death_timeout():
	kil.kill()
	queue_free()

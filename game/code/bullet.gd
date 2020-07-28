extends KinematicBody

var speed = 50
var velocity = Vector3()

func _ready():
	velocity = Vector3(speed, 0, 0)
	add_to_group("bullet")

func set_speed(blyat):
	velocity = blyat.normalized()*speed

func _physics_process(delta):
	move_and_slide(velocity, Vector3(0, 0, 0), false, 3, 0.785398, false)
	for i in get_slide_count():
		var col = get_slide_collision(i)
		var queue_free = true
		if(col):
			print(col.collider.name)
			var groups = col.collider.get_groups()
			for g in groups:
				if(g == "explosive"):
					col.collider.explode()
					
				if(g == "enemy"):
					# col.collider.apply_central_impulse(-col.normal*3)
					print("Tried to hurt someone")
		
					
				elif (g == "Player"):
					print("Player was hurt!")
					
				if(g == "case"):
					queue_free = false
		
		if(queue_free):
			queue_free()

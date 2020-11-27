extends KinematicBody
onready var heal = get_node("/root/level/Player")
var speed = 50
var velocity = Vector3()
#signal change_colour
var damage
func _ready():
	velocity = Vector3(speed, 0, 0)
	add_to_group("bullet")

func set_speed(blyat):
	velocity = blyat.normalized()*speed
func set_damage(dam):
	damage=dam
func _physics_process(_delta):
	var _ret = move_and_slide(velocity, Vector3(0, 0, 0), false, 3, 0.785398, false)
	var queue_free = false
	var slide_count = get_slide_count()
	
	for i in slide_count:
		var col = get_slide_collision(i)
		if(col):
			print(col.collider.name)
			queue_free = true
			var groups = col.collider.get_groups()
			
			if(groups.has("explosive")):
				col.collider.explode()
				break
			if(groups.has("enemy")):
				col.collider.die(1)
				break
			if(groups.has("turret")):
				col.collider.die(1)
				break
			if(groups.has("rocket")):
				col.collider.die(1)
				break
			if(groups.has("Player")):
				if(slide_count == 1):
					col.collider.hurt()
					Engine.time_scale = 1
					heal.health=heal.health-1
					print("Player was hurt!")
	
	if(queue_free):
			queue_free()

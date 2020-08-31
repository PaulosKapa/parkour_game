extends StaticBody

onready var kil = get_node("/root/level/Player")

func die():
	kil.kill()
	queue_free()

extends StaticBody

onready var kil = get_node("/root/level/Player")

func die(damage):
	kil.kill()
	queue_free()

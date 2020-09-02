extends StaticBody

onready var kil = get_node("/root/level/Player")
#damage parameter in keeping with how it is called in bullet.gd:31
#that, is, it prevents "Invalid call to function 'die' . Expected 0 arguments"
#(FLJ, 9/2/2020)
func die(damage):
	kil.kill()
	queue_free()

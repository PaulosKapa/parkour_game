extends Spatial
var mouse = Vector2()
var new_mouse =Vector2()
onready var player =get_node("/root/level/Player")
var res = OS.get_screen_size()

func _ready():
	pass

#it rotates on the z axis too. It is an undesirable effct.
#it lags. It is because of the time needed to calculate new_mouse. 
func _process(delta):
	mouse = get_tree().root.get_mouse_position()
	if new_mouse!=mouse:
		#if mouse.y>res.y/2:
		#	player.rotate_x(deg2rad(-1))
		#elif mouse.y<res.y/2:
			#player.rotate_x(deg2rad(1))
		if mouse.x>res.x/2:
			player.rotate_y(deg2rad(-1))
		elif mouse.x<res.x/2:
			player.rotate_y(deg2rad(1))

		
	new_mouse = get_tree().root.get_mouse_position()

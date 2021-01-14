extends Node2D


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(delta):
	#$Viewport/Spatial/cursor/Cube2.rotate_y(rad2deg(0.001))
	var texture = $Viewport.get_texture()
	$Sprite.position= get_global_mouse_position()
	$Sprite.texture = texture

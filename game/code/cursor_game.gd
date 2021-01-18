extends Node2D


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(delta):
	if Input.is_action_pressed("click"):
		$Viewport/cursor_game/AnimationPlayer.play("cursor")
	if Input.is_action_just_released("click"):
		$Viewport/cursor_game/AnimationPlayer.stop()
		#want to make the animation go back to frame 0
	var texture = $Viewport.get_texture()
	$Sprite.position= get_global_mouse_position()
	$Sprite.texture = texture

extends Spatial
onready var anim_player = $AnimationPlayer1
onready var anim_player2 = $AnimationPlayer2

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_up"):
		anim_player2.play("jump")
	if Input.is_action_pressed("ui_fwd"):
		anim_player.play("walking")
	elif Input.is_action_pressed("ui_rvs"):
		anim_player.play("walking")
	if Input.is_action_pressed("ui_left"):
		anim_player.play("walking")
	elif Input.is_action_pressed("ui_right"):
		anim_player.play("walking")
	if Input.is_action_just_pressed("ui_left"):
		rotate_y(-90)
	elif Input.is_action_just_pressed("ui_right"):
		rotate_y(90)
	if Input.is_action_just_released("ui_left"):
		rotate_y(90)
	elif Input.is_action_just_released("ui_right"):
		rotate_y(-90)

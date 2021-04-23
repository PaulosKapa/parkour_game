extends Area



func _on_Area_body_entered(body):
	if body.is_in_group("Player"):
		Engine.time_scale = 1
		#Restore from checkpoint if the player lands in this lava pit
		#Both calls probably should be replaced by a single "body.health = 0"
		#(FLJ, 9/1/2020)
		var next_scene_filename = GameData.restore("user://saves")
		#1. As an onready, this load was fouling up the game start
		#2. The only time exit.gd uses it is here
		#As such, it seemed better to move it to here instead of the onready where it was causing delays
		#(FLJ, 3/7/2021)
		var next_scene = load(next_scene_filename)
		var _ret = Global.goto_scene(next_scene)


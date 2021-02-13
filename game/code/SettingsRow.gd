extends MeshInstance	
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var vol1 = get_node("/root/Spatial/settingspanel/SoundCube/VolBall001")
onready var vol2 = get_node("/root/Spatial/settingspanel/SoundCube/VolBall002")
onready var vol3 = get_node("/root/Spatial/settingspanel/SoundCube/VolBall003")
onready var vol4 = get_node("/root/Spatial/settingspanel/SoundCube/VolBall004")
onready var vol5 = get_node("/root/Spatial/settingspanel/SoundCube/VolBall005")
onready var vol6 = get_node("/root/Spatial/settingspanel/SoundCube/VolBall006")
onready var full_on = get_node("/root/Spatial/settingspanel/OnSphere")
onready var full_off = get_node("/root/Spatial/settingspanel/OffSphere")
var shown_res = 0
var shown_audio = 0
var shown_full = 0
export var settingName:String
export var spheres: Array
var sphere_objects = []
var already_clicked = false
var deployed = true
var settingValue:String

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in spheres:
		var gotcha = find_node(i)
		$Clicktime.connect("timeout",gotcha,"_on_Clicktime_timeout")
		sphere_objects.append(gotcha)
	#$ClickCubeArea_audio.connect("input_event",self,"_on_CubeArea_input_event")
	#$ClickCubeArea.connect("input_event",self,"_on_CubeArea_input_event")
	$Clicktime.connect("timeout",self,"_on_Clicktime_timeout")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_CubeArea_input_event(_camera, event, _click_position, _click_normal, _shape_idx):
	if event.get_class() != "InputEventMouseButton":
		return
#	if already_clicked:
#		return
	return
#	deployed = !deployed
#	if deployed :
#		for sphere in sphere_objects:
#			sphere.show()
#	else:
#		for sphere in sphere_objects:
#			sphere.hide()
#	already_clicked = true
#
#	$Clicktime.start(.20) 
	


func _on_Clicktime_timeout():
	already_clicked = false

func set_value(new_value):
	settingValue = new_value
	get_parent().update_setting(settingName,settingValue)

func init_value(old_value):
	settingValue = old_value
	if sphere_objects.size() == 1:
		sphere_objects[0].init_value(settingValue)
		return	
	for sphere in sphere_objects:
		if sphere.selectedValue == settingValue:
			sphere.activate()
		else:
			sphere.deactivate()


func _on_ClickCubeArea_mouse_entered():
	match shown_res:
		0: 
			$ResolutionBall.show()
			shown_res = 1
		1:
			$ResolutionBall.hide()
			shown_res = 0


func _on_ClickCubeArea_audio_mouse_entered():
	match shown_audio:
		0: 
			vol1.show()
			vol2.show()
			vol3.show()
			vol4.show()
			vol5.show()
			vol6.show()
			shown_audio = 1
		1:
			vol1.hide()
			vol2.hide()
			vol3.hide()
			vol4.hide()
			vol5.hide()
			vol6.hide()
			shown_audio = 0


func _on_ClickCubeArea_ful_mouse_entered():
	match shown_full:
		0: 
			#full_off.show()
			full_on.show()
		1:
		#	full_off.hide()
			full_on.hide()

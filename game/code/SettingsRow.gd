extends MeshInstance	
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
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
	$ClickCubeArea.connect("input_event",self,"_on_CubeArea_input_event")
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

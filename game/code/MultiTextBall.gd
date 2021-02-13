extends Spatial

var resLabels = [
	preload("res://models/Label_1366x768.material"),
	preload("res://models/Label_1920x1080.material"),
	preload("res://models/Label_2560x1440.material"),
	preload("res://models/Label_3840x2160.material")
]

var resValues = [
	"1366x768",
	"1920x1080",
	"2560x1440",
	"3840x2160"
]
var whichResSetting = 0
var already_clicked = false

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$MultiTextBallArea.connect("input_event",self,"_on_ResBallArea_input_event")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_ResBallArea_input_event(_camera, event, _click_position, _click_normal, _shape_idx):
	if event.get_class() != "InputEventMouseButton":
		return
	if already_clicked:
		return
	
	print("AHA:",name)
	$click.play()
	whichResSetting = (whichResSetting + 1) % resLabels.size()
	$Sphere.material_override = resLabels[whichResSetting]
	get_parent().set_value(resValues[whichResSetting])
	already_clicked = true
	get_parent().find_node("Clicktime").start(.20)


func _on_Clicktime_timeout():
	already_clicked = false

func init_value(currentValue):
	whichResSetting = resValues.find(currentValue)
	if whichResSetting > -1:
		$Sphere.material_override = resLabels[whichResSetting]
	else:
		print("FAIL!",currentValue, " not found")
	

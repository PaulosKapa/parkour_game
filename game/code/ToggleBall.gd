extends MeshInstance


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#var fullscreenOnMatl = preload("res://models/SettingsGreenSelected.material")
#var fullscreenOffMatl = preload("res://models/SettingsRedSelected.material")
var onMatl
export var material_when_lit:Material
var already_clicked = false
var lit = false
export var selectedValue:String
export var other_switch:String
# Called when the node enters the scene tree for the first time.
func _ready():
	onMatl = (material_when_lit)
	#other = get_parent().find_node(other_switch)
	$ToggleArea.connect("input_event",self,"_on_ToggleArea_input_event")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Clicktime_timeout():
	already_clicked = false

func _on_ToggleArea_input_event(_camera, event, _click_position, _click_normal, _shape_idx):
	if event.get_class() != "InputEventMouseButton":
		return
	if already_clicked:
		return
	if lit: 
		return
		
	for sphere in get_parent().sphere_objects:
		if sphere != self:
			sphere.deactivate()
	self.activate()
	
func deactivate():
	lit = false
	material_override = null
	
func activate():
	lit = true
	$click.play()
	get_parent().set_value(selectedValue)
	material_override = onMatl

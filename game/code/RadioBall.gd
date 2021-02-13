extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var on_material:Material
var lit = false
var meshlet:MeshInstance
export var selectedValue:String
var already_clicked = false
# Called when the node enters the scene tree for the first time.
func _ready():
	#other = get_parent().find_node(other_switch)
	meshlet = self.find_node("Sphere")
	self.find_node("ToggleArea").connect("input_event",self,"_on_ToggleArea_input_event")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func deactivate():
	lit = false
	meshlet.material_override = null
	
func activate(is_not_init):
	lit = true
	
	if(is_not_init):
		$click.play()
	get_parent().set_value(selectedValue)
	meshlet.material_override = on_material
	
func _on_ToggleArea_input_event(_camera, event, _click_position, _click_normal, _shape_idx):
	if event.get_class() != "InputEventMouseButton":
		return
	if lit: 
		return
		
	for sphere in get_parent().sphere_objects:
		if sphere != self:
			sphere.deactivate()
	self.activate(true)

func _on_Clicktime_timeout():
	already_clicked = false

extends Spatial

var settings = {"Resolution":"1366x768",
	"Fullscreen":"Off",
	"Sound":"3"
}

var prefs_filename = "user://prefs.json"

var rows = {}
func update_setting(name,value):
	settings[name] = value
	apply_settings()
	var prefs_file = File.new()
	var result =  prefs_file.open(prefs_filename,File.WRITE)
	#if result == ERR_FILE_NOT_FOUND:
		#result = create_directory(directory)
		#if result == OK:
		#	result =  prefs_file.open(prefs_filename,File.WRITE)
	if result == OK:
		prefs_file.store_line(to_json(settings))
		prefs_file.close()
		return
	#if we're here, something went wrong
	print("ERROR:",result," ", prefs_filename)
	#GameData.run_alert(result,prefs_filename)
		


func load_settings():
	var prefs_file = File.new()
	#if it doesn't yet exist, use the defaults shown above
	if not prefs_file.file_exists(prefs_filename):
		apply_settings()
		return
	
	var result = prefs_file.open(prefs_filename,File.READ)
	if result != OK :
		print("ERROR:",result," ", prefs_filename)
		#GameData.run_alert(result,prefs_filename)
		apply_settings()
		return
	settings = parse_json(prefs_file.get_line())
	prefs_file.close()
	apply_settings()
	
func apply_settings():
	var screen_dims = settings["Resolution"].split_floats("x",false)
	OS.window_size=Vector2(screen_dims[0] ,screen_dims[1])
	if settings["Fullscreen"]=="Off":
		OS.window_fullscreen = false
	else:
		OS.window_fullscreen = true
	#now the audio. I went with the premise that setting 3 should have half the wattage of setting 5
	#as opposed to being halfway down the decibel scale (which would've been -30)
	var bus_index = AudioServer.get_bus_index("Master")
	match settings["Sound"]:
		"5":
			AudioServer.set_bus_mute(bus_index,false)
			AudioServer.set_bus_volume_db(bus_index,0)
		"4":
			AudioServer.set_bus_mute(bus_index,false)
			AudioServer.set_bus_volume_db(bus_index,-3)
		"3":
			AudioServer.set_bus_mute(bus_index,false)
			AudioServer.set_bus_volume_db(bus_index,-6)
		"2":
			AudioServer.set_bus_mute(bus_index,false)
			AudioServer.set_bus_volume_db(bus_index,-12)
		"1":
			AudioServer.set_bus_mute(bus_index,false)
			AudioServer.set_bus_volume_db(bus_index,-18)
		_:
			AudioServer.set_bus_mute(bus_index,true)
		
			
	
func _ready():
	load_settings()
	for row in get_children():
		if !row.has_method("init_value"):
			continue
		row.init_value(settings[row.settingName])
			
	pass
#
## Declare member variables here. Examples:
## var a = 2
## var b = "text"
#var fullscreenOnMatl = preload("res://models/SettingsGreenSelected.material")
#var fullscreenOffMatl = preload("res://models/SettingsRedSelected.material")
#var resLabels = [
#	preload("res://models/Label_1366x768.material"),
#	preload("res://models/Label_1920x1080.material"),
#	preload("res://models/Label_2560x1440.material"),
#	preload("res://models/Label_3840x2160.material")
#]
#var whichResSetting = 0
#var already_clicked = false
#var fullscreen_deployed = false
#
## Called when the node enters the scene tree for the first time.
#func _ready():
#	pass
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
#
#
#func _on_OnSphereArea_input_event(camera, event, click_position, click_normal, shape_idx):
#	if event.get_class() != "InputEventMouseButton":
#		return 
#	$OffSphere.material_override = null
#	$OnSphere.material_override = fullscreenOnMatl
#	pass # Replace with function body.
#
#
#func _on_OffSphereArea_input_event(camera, event, click_position, click_normal, shape_idx):
#	if event.get_class() != "InputEventMouseButton":
#		return
#	$OnSphere.material_override = null
#	$OffSphere.material_override = fullscreenOffMatl
#
#
#func _on_ResBallArea_input_event(camera, event, click_position, click_normal, shape_idx):
#	if event.get_class() != "InputEventMouseButton":
#		return
#	if already_clicked:
#		return
#	whichResSetting = (whichResSetting + 1) % resLabels.size()
#	$ResolutionBall/Sphere.material_override = resLabels[whichResSetting]
#	already_clicked = true
#	$Clicktime.start(.20)
#
#
#func _on_Clicktime_timeout():
#	already_clicked = false
#
#
#func _on_FSCubeArea_input_event(camera, event, click_position, click_normal, shape_idx):
#	if event.get_class() != "InputEventMouseButton":
#		return
#	if already_clicked:
#		return
#	fullscreen_deployed = !fullscreen_deployed
#	if fullscreen_deployed :
#		$OnSphere.show()
#		$OffSphere.show()
#	else:
#		$OnSphere.hide()
#		$OffSphere.hide()
#	already_clicked = true
#	$Clicktime.start(.20)
#

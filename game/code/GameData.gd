extends Node

var stages = []
var inventory = [] #equipment the player has acquired

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#errno:int - see https://docs.godotengine.org/en/stable/classes/class_@globalscope.html#enum-globalscope-error 
#intended_path:String 
func run_alert(errno, intended_path):
	var message
	match errno:
		ERR_FILE_NOT_FOUND:
			message="File "+intended_path+" not found"
		ERR_FILE_NO_PERMISSION:
			message="Not permitted access to "+intended_path
		ERR_FILE_BAD_PATH:
			message="Directory path not available"
		_:
			message="General file I/O error "+errno.to_string()+" with "+intended_path
	print("ERROR:"+message)

#path:String
func create_directory(path):
	var dir = Directory.new()
	if dir.dir_exists(path):
		return
	return dir.make_dir_recursive(path)	

#directory:String - folder into which the game save files are going
func save(directory):
	var save_file = File.new()
	var result =  save_file.open(directory+"/progress.save",File.WRITE)
	if result == ERR_FILE_NOT_FOUND:
		result = create_directory(directory)
		if result == OK:
			result =  save_file.open(directory+"/progress.save",File.WRITE)
	if result == OK:
		save_file.store_line(to_json(stages))
		save_file.store_line(to_json(inventory))
		save_file.close()
		return
	#if we're here, we have a problem
	run_alert(result,directory+"/progress.save")
	
#stage_name:String	
func completed_stage(stage_name):
	pass

extends Node

var stages = []
var inventory = [] #equipment the player has acquired
var player_status = {}
var props = {}
var remaining_enemies = {}
var _player_location = Vector3(100,100,100) # z == 100 used to detect this being not-yet set
var _player_node 
var prop_groups = ["explosive","key","door"]
var restore_armed = false

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
#checkpoint_name: String
#player_node: Spatial (or subclass thereof) with members defined in player.gd
func set_player_status(checkpoint_name, player_node):
	player_status = {
		"health":player_node.health,
		"kills":player_node.kill_var,
		"last_checkpoint":checkpoint_name
	}


#player_node: Spatial (or subclass thereof) with members defined in player.gd	
func restore_player_status():
	if not _player_node or _player_node == null:
		return
	if _player_location.z == 100:
		return
	_player_node.health = int(player_status["health"])
	_player_node.kill_var = int(player_status["kills"])
	_position_player()
	
func _position_player():
	if not _player_node:
		return
	if _player_location.z == 100:
		return
	_player_node.global_transform.origin = _player_location

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
			message="General file I/O error "+str(errno)+" with "+intended_path
	print("ERROR:"+message)

#path:String
func create_directory(path):
	var dir = Directory.new()
	if dir.dir_exists(path):
		return
	return dir.make_dir_recursive(path)	

#directory:String - folder into which the game save files are going
func save(directory):
	var scenetree = Global.get_tree()
	if stages.find_last(scenetree.current_scene.name) == -1:
		stages.append(scenetree.current_scene.name)
	if (player_status.empty()):
		print("ERROR:called GameData.save() before calling GameData.set_player_status()")
		return
	#enemies not yet defeated
	var enemies_left =  scenetree.get_nodes_in_group("enemy")

	for enem in enemies_left:
		remaining_enemies[enem.name+"_enemy"] ={
		"position":enem.global_transform.origin,
		"orientation":enem.rotation
		}
	#now the turrets
	#had to add type information due to multiple objects having the same name
	enemies_left =  scenetree.get_nodes_in_group("turret")
	for enem in enemies_left:
		remaining_enemies[enem.name+"_turret"] ={
		"position":enem.global_transform.origin,
		"orientation":enem.rotation
		}
	
	#if enemy health were a thing, "health":enem.health would be in that Dictionary
	
	#now, things get harder: the other objects on the stage
	var explosives_left = scenetree.get_nodes_in_group("explosive")
	for ex in explosives_left:
		if(ex.visible):
			props[ex.name]= {
			"type":"explosive"
			}
	var props_left = scenetree.get_nodes_in_group("prop")
	for p in props_left:
		props[p.name] = _prop_data(p)
	
	var save_file = File.new()
	var result =  save_file.open(directory+"/progress.save",File.WRITE)
	if result == ERR_FILE_NOT_FOUND:
		result = create_directory(directory)
		if result == OK:
			result =  save_file.open(directory+"/progress.save",File.WRITE)
	if result == OK:
		save_file.store_line(to_json(stages))
		save_file.store_line(to_json(inventory))
		save_file.store_line(to_json(player_status))
		save_file.store_line(to_json(remaining_enemies))
		save_file.store_line(to_json(props))
		save_file.close()
		return
	#if we're here, we have a problem
	run_alert(result,directory+"/progress.save")

#prop : Subclass of Node implementing a door, or key
#We've counted un-detonated explosives as props earlier
func _prop_data(prop):
	var groups = prop.get_groups()
	if(groups.find_last("door") >-1):
		return {
			"type":"door",
			"id":prop.name,
			"status":prop.unl_door
			}
	if(groups.find_last("key") >-1):
		return {
			"type":"key",
			"id":prop.name
			}
	
#stage_name:String	
func completed_stage(_stage_name):
	pass

func restore(directory):
	var save_file = File.new()
	if not save_file.file_exists(directory+"/progress.save"):
		return
	var result = save_file.open(directory+"/progress.save",File.READ)
	if result != OK:
		run_alert(result,directory+"/progress.save")
		return
	stages = parse_json(save_file.get_line())
	inventory = parse_json(save_file.get_line())
	player_status = parse_json(save_file.get_line())
	remaining_enemies = parse_json(save_file.get_line())
	props = parse_json(save_file.get_line())
	save_file.close()
	var scenetree = Global.get_tree()
	#set the stage
	#we'll need a second level to test this part
	#as well as a list of all the level filenames or indices
	#this is from the fact that current_scene.name is "level", not "1st_stage"
#	if stages[-1] != Global.current_scene.name:
#		scenetree.change_scene("res://scenes/"+stages[-1])
	if(not restore_armed):
		scenetree.connect("node_added",self,"_on_SceneTree_node_added")
		restore_armed = true
	

func _on_SceneTree_node_added(new_node):
	#we can't be sure whether the Checkpoints will be added before the Player 
	#or the other way around
	#this "primes" it when one gets added, and the arrival of the other springs _position_player()
	#objective is to position the player at the last checkpoint, and remove that instance from 
	#future consideration
	
	#Object.get_class() does not return program-defined class names, but that of the "intrinsic" superclass
	
	if new_node.name.begins_with("Checkpoint") and new_node.name == player_status["last_checkpoint"]:
		_player_location = new_node.global_transform.origin
		#new_node.queue_free()
		restore_player_status()
		return
	if new_node.is_in_group("Player"):
		_player_node = new_node
		restore_player_status()
		return
	
	#enemy objects
	if new_node.is_in_group("enemy") or new_node.is_in_group("turret"):
		#if the player took it out during the previous run, don't restore it
		var querie = new_node.name
		if new_node.is_in_group("turret"):
			querie += "_turret"
		else:
			querie += "_enemy"
		var hit = remaining_enemies.has(querie)
			
		if not hit:
			new_node.queue_free()
		else:
			#apply its position and orientation at the time the Checkpoint was hit during the prior run
			new_node.rotation = _toVector3(remaining_enemies[querie]["orientation"])
			new_node.global_transform.origin = _toVector3(remaining_enemies[querie]["position"])
		return
	
	#now, stationary props (exploding barrels, keys, doors)
	
	for proptype in prop_groups:
		if not new_node.is_in_group(proptype):
			continue
		#so it's in one of the prop groups
		#if it wasn't there at the time the player hit the Checkpoint, don't restore it
		if not props.has(new_node.name):
			new_node.queue_free()
			return
		if props[new_node.name]["type"] == "door": new_node.unl_door = props[new_node.name]["status"]
	
	
#convert a String to a Vector3 because JSON doesn't do complex types	
func _toVector3(in_val):
	if typeof(in_val) == TYPE_VECTOR3:
		return in_val
	var subject = in_val.replace("(","").replace(")","")
	var coords = subject.split(",",false,3)
	return Vector3(float(coords[0]),float(coords[1]),float(coords[2]))

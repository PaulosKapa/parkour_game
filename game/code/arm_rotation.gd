extends Spatial

var skel
var arm_angle = Vector3()

var ray_origin = Vector3()
var ray_target=Vector3()

onready var cam = get_node("/root/level/Player/Camera2")


func _ready():
	skel = get_node("Armature/Skeleton")
	set_process(true)

# bone: string, name of the bone we want to perform an operation on
# angle: Vector3, the vector along which we want the bone to align itself
func set_bone_rotation(bone, angle):
	# For now, we only need to calculate z_angle, as the arms only rotate along that particular axis
	var z_angle = Vector2(angle.x, angle.y).angle_to(Vector2(0.0, 1.0))
	# If the need arises, these lines should calculate the angles along the other axes.
	# I have not tested these, modify if need be.
	# var x_angle = Vector2(angle.y, angle.z).angle_to(Vector2(0.0, 1.0))
	# var y_angle = Vector2(angle.x, angle.z).angle_to(Vector2(0.0, 1.0))
	
	# Get the specified bone
	var b = skel.find_bone(bone)
	
	# Rotate the bone position by a relative value
	var newpose = Transform.IDENTITY.rotated(Basis().z, z_angle - PI/2)
	# Again, if we need to rotate along some other axis, use these.
	# var newpose = newpose.rotated(Vector3(1.0, 0.0, 0.0), x_angle)
	# var newpose = newpose.rotated(Vector3(0.0, 1.0, 0.0), y_angle)
	
	# Set the bone's new position
	skel.set_bone_pose(b, newpose)

func _physics_process(_delta):
	# Get mouse position on screen
	var mouse_pos = get_viewport().get_mouse_position()
	
	# With the mouse position known, get the origin of a hit-detection ray
	# If the perspective is set to orthogonal, project_ray_origin is the same as project_ray_normal.
	# Otherwise project_ray_origin will return the position of the camera.
	ray_origin = cam.project_ray_origin(mouse_pos)
	# Get the end position of the ray.
	ray_target = cam.project_ray_normal(mouse_pos)*10000
	
	# Get the space state, essentially containing information about collision objects and the like.
	# Needed for the next line.
	var space_state = get_world().direct_space_state
	# Check for possible obstacles. In this game, we (should) only have one collision object on layer 
	# two, an invisible box that covers the whole view. This allows us to still use this algorithm 
	# even if the player is in the void.
	var ray = space_state.intersect_ray(ray_origin, ray_target, [self], 2, true, true)
	
	# If we for some reason don't hit anything, we skip the following section so that the game doesn't crash
	if ray:
		var ray_collision_point = ray.position
		var object_position = $RotationPoint.global_transform.origin
		# arm_angle is a vector that points towards the cursor from the rotation point
		# Since we want our arms to also point towards the cursor, we can pass arm_angle as is
		# to set_bone_rotation
		arm_angle = ray_collision_point - object_position
	
	set_bone_rotation("l_shoulder", arm_angle)
	set_bone_rotation("r_shoulder", arm_angle)

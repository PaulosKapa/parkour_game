extends Spatial

#Pulled these in from earlier Player code
#onready var animation= get_node("/root/level/Player/animation")
enum {FACING_LEFT, FACING_RIGHT}
var facing = FACING_LEFT

var ray_origin = Vector3()
var ray_target = Vector3()

onready var cam = get_node("/root/level/InterpolatedCamera")
onready var backplane = get_node("/root/level/InterpolatedCamera/StaticBody")


onready var skel = $Armature/Skeleton
var left_arm
var right_arm
var max_armswing = PI/4
var aim_angle = 0
var sought_angle = 0
var shoulder_delta_height

var end_rot = 1000.0  #used when there is no ending rotation about Y axis; when there is one -(2*PI) <= end_rot <=(2*PI)
var turn_speed = PI*4 #radians per second

# Called when the node enters the scene tree for the first time.
func _ready():
	left_arm = skel.find_bone("arm_l") # was named Arm.L in Blender
	right_arm = skel.find_bone("arm_r")
	sought_angle = 0
	var tilty = skel.get_bone_global_pose(right_arm)
	shoulder_delta_height = (to_global(tilty.origin)-global_transform.origin).y
	
func aim(delta_angle):
	var tilty= skel.get_bone_pose(left_arm)
	tilty= tilty.rotated(Vector3.FORWARD,delta_angle)
	skel.set_bone_pose(left_arm,tilty)
	
	tilty= skel.get_bone_pose(right_arm)
	tilty= tilty.rotated(Vector3.RIGHT,delta_angle)
	skel.set_bone_pose(right_arm,tilty)
	aim_angle += delta_angle
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var d_angle = sought_angle - aim_angle
	if(abs(d_angle) < 0.1):
		return
	d_angle = sign(d_angle)*0.1
	
	if(d_angle < 0):
		if(aim_angle+d_angle<sought_angle):
			d_angle = sought_angle - aim_angle
	if(d_angle > 0):
		if(aim_angle+d_angle>sought_angle):
			d_angle = sought_angle - aim_angle
		
			
	aim(d_angle)
	

#and most importantly, this

func _physics_process(delta):
	var mouse_pos = get_viewport().get_mouse_position()
	ray_origin = cam.project_ray_origin(mouse_pos)
	ray_target = cam.project_ray_normal(mouse_pos)*10.0000
	
	var space_state = get_world().direct_space_state
	var ray = space_state.intersect_ray(ray_origin,ray_target,[self],2,true,true)
	
	if ray:
		var ray_collision_point = ray.position
		var object_position = backplane.global_transform.origin # +Vector3(0,1.3,0)
		ray_collision_point = ray_collision_point - object_position
		var x_dir =  1
		if facing == FACING_RIGHT:
			x_dir = -1
		var angle = Vector2(x_dir*ray_collision_point.x, ray_collision_point.y).angle_to(Vector2(-1, 0))

		
		if still_turning(delta):
			return
		
		if facing == FACING_LEFT and abs(angle) > PI/2:
			facing = FACING_RIGHT
			start_turn(PI)
			return
		if facing == FACING_RIGHT and abs(angle) > PI/2:
			facing = FACING_LEFT
			start_turn(-PI)
		
		if	abs(angle) <= max_armswing:
			sought_angle = angle
			return		
		
		

func start_turn(by_angle):
	end_rot = rotation.y+by_angle
	
func still_turning(delta_time):
	if end_rot > 900:
		return false
	var dspin = turn_speed * delta_time
	if(abs(end_rot - rotation.y) < abs(.5*dspin)):
		end_rot=1000.0
		return false
	rotate_y(dspin)
	return true

#TODO: 
#1. copy in the movement and health-related code from swerve.gd, s.gd, and player.gd
#2. confirm the movement and battle (firing, taking hits, and fatal mis-steps) parts work with this Player implementation
#2a. adjust the copied-in code as needed
#3. Work out the "walk" and "dash" Animations in Godot, This is necessary for properly-moving collision shapes for each leg.


extends CharacterBody3D

var player = null
var state_machine 
var health = 10

var next_nav_point

var navigation_start_frame
var spawn_frame

var frames_till_calc_navigation = 5 #navigation calculates route every blank frames 

const SPEED = 2.0
const ATTACK_RANGE = 2.5



@export var player_path:= "/root/World/Player" 

@onready var nav_agent = $NavigationAgent3D
@onready var anim_tree = $AnimationTree

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node(player_path)
	state_machine = anim_tree.get("parameters/playback")
	randomize()
	navigation_start_frame = randi() % 120
	spawn_frame = Engine.get_frames_drawn()
	frames_till_calc_navigation = 10
	nav_agent.set_target_position (player.global_transform.origin)
	next_nav_point = nav_agent.get_next_path_position()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	velocity= Vector3.ZERO	
	
	var call_navigation_every_blank_frames = call_navigation_every_blank_frames()
	var _is_or_past_starting_frame = _is_or_past_starting_frame()
	match state_machine.get_current_node():
		"Zombie Run 2": #Running
			if _is_or_past_starting_frame == true && call_navigation_every_blank_frames == true:
				# Navigation
				nav_agent.set_target_position (player.global_transform.origin)
			next_nav_point = nav_agent.get_next_path_position()
			velocity = ((next_nav_point - (global_transform.origin)).normalized() * SPEED )
			rotation.y = lerp_angle(rotation.y,atan2(-velocity.x, -velocity.z), delta * 10.0)
			#look_at(Vector3(global_position.x + velocity.x, global_position.y, global_position.z+velocity.z), Vector3.UP)
		"Zombie Attack 2":
			look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
			
	
	
	#Conditions
	anim_tree.set("parameters/conditions/attack", _target_in_range())
	anim_tree.set("parameters/conditions/run", !_target_in_range())
	
	
	anim_tree.get("parameters/playback")
	
	move_and_slide()

func _target_in_range():
	return global_position.distance_to(player.global_position) < ATTACK_RANGE

func  _hit_finished():
	if global_position.distance_to(player.global_position) < ATTACK_RANGE + 0.7:
		var dir = global_position.direction_to(player.global_position)
		player.hit(dir)

func _is_or_past_starting_frame():
	if Engine.get_frames_drawn() - spawn_frame >= navigation_start_frame:
		return true
	else:
		return false

func call_navigation_every_blank_frames():
	
	if Engine.get_frames_drawn() % frames_till_calc_navigation == 0:
		return true
		
	else:
		return false
		







func _on_area_3d_body_part_hit(damage):
	health -= damage
	if health <= 0:
		queue_free()

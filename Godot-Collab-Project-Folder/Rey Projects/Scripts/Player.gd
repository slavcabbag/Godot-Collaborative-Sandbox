extends CharacterBody3D

#blah blah heres the fun stuff

var bug1 = false #ACTIVATE: just keep running around for a bit until you go BRRRR
	#makes headbob offset go crazy when ramp_up_on_move 
	# gets to about 1.4-1.6.  If I set the headbob time value to a certain
	# amount I can affect the direction, thus I can control if the headbob
	# offset reset goes from the bottom of the map or
	# from the top, adding a cool effect

# Custom speeds
# (VELOCITY): affects when not moving at all and in air
# (SPEED COUNTER): affects only when moving, speed_counter gradually increases as you move

#INERTIA : Lower = more, Higher = less


# v Change these at your own risk v / Don't change
var speed_limit_lerp = false # Starts when sprint is released, 
	# ^used to make you slow to a walk pace instead of instantly
var moving = false # is a direction being pressed (w,s,a,d)
var exponential_speed = 1.0 # Initial Speed 
var speed_counter = 2.0 # Initial Speed
var Speed_Limit = 0.0 # Speed Limit switches between Sprint and Walking Speed Limits
var speed
const FOV_CHANGE = 2.5

#Medium Danger if changed / can experiment
# v AFFECTS HOW FAST ACCELERATION IS VERY MUCH
const EXPONENTIAL_RATE = 0.1 # How fast speed_counter grows
# Used In: speed_counter += EXPONENTIAL_RATE
const EXPONENTIAL_LIMIT = 10.0 # Max that the exponential can go
const SPEED_COUNTER_DECELERATE = 7.0 # How fast the exponential rate decreases (SPEED COUNTER)
const DECELERATION_SPEED = 2.0 # Higher = less # How fast the speed decreases when not holding a direction (INCREASES INERTIA) (VELOCITY)
const WALK_EXPONENTIAL_RATE_REDUCER = 1.0 # a little tweaking number for walk speed decrease 
# Used In: speed_counter += EXPONENTIAL_RATE * WALK_EXPONENTIAL_RATE_REDUCER [In walk part of sprint code] 
const RESUME_SPRINT_BUFFER = 9.0 # When sprint is pressed again, can resume sprint if
	# Speed_limit is higher than sprint speed limit - buffer, higher the buffer lower 
	# the threshold is to resume sprint
# Used in 
##
#	if Input.is_action_just_pressed("Sprint"):
#		if speed_limit_lerp  && Speed_Limit > SPRINT_SPEED_LIMIT - RESUME_SPRINT_BUFFER:
#			pass
#		else:
#			speed_counter = 0.1
##

#Change Self explanatory, have fun
const SPRINT_TO_WALK_SLOWDOWN_RATE = 7.0 # Rate you switch to walk speed after releasing sprint
const EXPONENTIAL_WALK_SPEED = 2.0 # Speed when Shift is NOT held
const SPRINT_SPEED_LIMIT = 9.0 # SPRINT_SPEED_LIMIT is max players speed can go while SPRINTING
const WALK_SPEED_LIMIT = 4.5 # WALK_SPEED_LIMIT is max players speed can go while WALKING
# CHANGING ONLY CHANGES START VALUE
var Fast_Sprint_Inertia = 3.5 # How much drag/inertia you will have when you are at 
var Walk_Inertia = 5.0
# I made it so Inertia gets lower the less your speed is so its not rigid
# Slows your turns at high speeds 
# speeds higher than FAST_SPEED
const FAST_SPEED = 6.0 # How fast you have to go before being affected by inertia
# v Still can change v Affects how fast you speed up kinda, tweaks 
const WALK_SPEED = 5.0
const SPRINT_SPEED = 7.0


const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.0018
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 9.8

# bob variables
var ramp_up_on_move = 0.0 # lerp counter that ramps up to align the cameras position
# with the zero'd position slowly, not jankily
const BOB_FREQUENCY = 2.0
const BOB_AMPLITUDE = 0.08
var t_bob = 0.0 # determine how far along the sine wave we are

# FOV Variables
const BASE_FOV = 75.0


@onready var head = $Head
@onready var camera = $Head/Camera3D

#debug
@onready var label = $Head/Camera3D/Label

# Get rid of cursor
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-70), deg_to_rad(70))

func _physics_process(delta):
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Reset Speed_Counter on Sprint Pressed 
		#unless its really close to the sprint limit already
	
	# When sprint is pressed again, can resume sprint if
	# Speed_Limit is higher than sprint speed limit - buffer, higher the buffer lower 
	# the threshold is to resume sprint
	if Input.is_action_just_pressed("Sprint"):
		if speed_limit_lerp  && Speed_Limit > SPRINT_SPEED_LIMIT - RESUME_SPRINT_BUFFER:
			pass
		else:
			speed_counter = 0.1
	# Handle Sprint.
	if Input.is_action_pressed("Sprint"):
		Speed_Limit = SPRINT_SPEED_LIMIT 
		speed = SPRINT_SPEED
		
		# While SPRINTING + MOVING,
		# accelerate to SPEED_LIMIT at a rate of EXPONENTIAL_RATE
		if moving == true:
			#Custom
			var clamped_exponential_speed 
			var clamped_speed_counter
			clamped_exponential_speed = clamp(speed/2.0 + speed_counter/5.0 * exponential_speed, 0.0, 10.0) 
			speed_counter += EXPONENTIAL_RATE #how fast speed_counter grows 
			speed_counter = clamp(speed_counter, 2.0, EXPONENTIAL_LIMIT) #Max that the exponential can go
			exponential_speed = speed/2 + speed_counter/5.0 * clamped_exponential_speed
			exponential_speed = clamp(exponential_speed,speed/2,Speed_Limit) #SPEED_LIMIT is max players speed can go 
			#^block of code that has to be kept together
	
	#When sprint is just realeased start slowing down to walk pace
	elif Input.is_action_just_released("Sprint"):
		speed_limit_lerp = true
	
	# If slowing_down_to_walk_pace = true (speed_limit_lerp), start doing that
	#until the walk speed is 0.5 from the bottom, then set the speed_limit to walk_speed 
	else:
		if speed_limit_lerp && Speed_Limit > WALK_SPEED_LIMIT+0.5:
			Speed_Limit = lerp(Speed_Limit, WALK_SPEED_LIMIT, delta * SPRINT_TO_WALK_SLOWDOWN_RATE)
		else:
			Speed_Limit = WALK_SPEED_LIMIT
			speed_limit_lerp = false
		
		speed = WALK_SPEED
	
		#Custom
		var clamped_exponential_speed 
		var clamped_speed_counter
		clamped_exponential_speed = clamp(speed/2.0 + speed_counter/5.0 * exponential_speed, 0.0, 10.0) 
		speed_counter += EXPONENTIAL_RATE * WALK_EXPONENTIAL_RATE_REDUCER #how fast speed_counter grows * a little tweaking number for walk
		speed_counter = clamp(speed_counter, 2.0, EXPONENTIAL_LIMIT) #Max that the exponential can go
		exponential_speed = speed/2 + speed_counter/5.0 * clamped_exponential_speed
		exponential_speed = clamp(exponential_speed,speed/2,Speed_Limit) #SPEED_LIMIT is max players speed can go 
		#^block of code that has to be kept together
		
	

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("Move_Left", "Move_Right", "Move_Forward", "Move_Backward")
	# Change direction from head, not body of character
	# (moves where your camera faces)
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	label.add_theme_color_override("font_color",Color(1.0,1.0,1.0,1.0))
	if is_on_floor():
		
		#INERTIA CONTROL
		if direction:
			moving = true
			

			#Slow your turns at high speeds
			#----------CURRENT WORK ON
			if exponential_speed > FAST_SPEED:
				velocity.x = lerp(velocity.x, direction.x * exponential_speed, delta * Fast_Sprint_Inertia)
				velocity.z = lerp(velocity.z, direction.z * exponential_speed, delta * Fast_Sprint_Inertia)
			else:
				
				velocity.x = lerp(velocity.x, direction.x * exponential_speed/1.25, delta * Walk_Inertia)
				velocity.z = lerp(velocity.z, direction.z * exponential_speed/1.25, delta * Walk_Inertia) 
			label.add_theme_color_override("font_color",Color(0.0,0.6,0.0,1.0))
			
		else:
			moving = false
			speed_counter = lerp(speed_counter,0.0, delta * 7.0) #Cusom
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 7.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 7.0)
	else:
		#speed_counter = lerp(speed_counter,0.0, delta * 3.0) #Custom
		velocity.x = lerp(velocity.x, direction.x * exponential_speed, delta * 3.0)
		velocity.z = lerp(velocity.z, direction.z * exponential_speed, delta * 3.0)
	label.text = "velocity x: " + str(velocity.x) + "\n velocity z: " + str(velocity.z) + \
			#used \ to continue long expression
			"\n direction x: " + str(direction.x) + "\n direction z: " + str(direction.z) \
			+ "\n \n exponential_speed: " + str(exponential_speed) \
			+ "\n \n speed_counter: " + str(speed_counter)\
			+ "\n \n speed_limit_lerp: " + str(speed_limit_lerp) \
			+ "\n \n camera_fov: " + str(camera.fov) \
			+ "\n \n t_bob: " + str(t_bob) \
			+ "\n \n _headbob function: " + str(_headbob(delta,t_bob))

	# head bob
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(delta,t_bob)

	# FOV
	var velocity_clamped = clamp(velocity.length(), 0.5, SPRINT_SPEED_LIMIT * 2)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped * (camera.transform.origin.length()/1.5) 
	# (camera.transform.origin.length()) is custom
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)
	

	move_and_slide()

func _headbob(delta, time) -> Vector3:
	var pos = camera.transform.origin
	var pos_camera_moving = Vector3.ZERO
	var sin_t_bob = clamp(sin(t_bob),0.0,1.0)

	label.text += "\n\n " + str(sin_t_bob) \
	+ "\n\n " + str(clamp(speed_counter -1.0 / EXPONENTIAL_LIMIT*2, 0.0, 1.0))

	if moving:
		# headbob movement: the headbobbing's head movement is an infinity sign because of sin and cos
			# because it used to stay at a certain change in transform your head would be
			# smaller or taller if you stopped moving at a certain time. I didn't like this
			# because it also means you can clip through gemoetry if nothing combats it
			# to stop this I reset the camera position to 0 slowly and over time 
			# when the player stops moving.
			# the camneras original position is still a separate thing so I also have to 
			# slowly move the camera up to that point and bring it back to that 
			# original camera position so everything stays butter smooth NO JITTERS!!
		var lerp_ramp_up_value
		if not bug1:
			ramp_up_on_move+= 0.001 * abs(velocity.x)
			ramp_up_on_move = clamp(ramp_up_on_move,0.0,1.0)
			lerp_ramp_up_value = clamp(delta*100.0*ramp_up_on_move, 0.0, 1.0)
		else:
			lerp_ramp_up_value = clamp(delta*100.0*ramp_up_on_move, 0.0, 200.0)
			ramp_up_on_move+= 0.001 * abs(velocity.x)
			
		
		
		
		
		
		label.text += "\n \n ramp_up_on_move: " + str(ramp_up_on_move) \
		+ "      lerp_ramp_up_value: " + str(lerp_ramp_up_value)
		
		pos_camera_moving.y = sin(time * BOB_FREQUENCY) * BOB_AMPLITUDE
		pos_camera_moving.x = cos(time * BOB_FREQUENCY/2) * BOB_AMPLITUDE
		pos.y = lerp(pos.y,pos_camera_moving.y, lerp_ramp_up_value)
		pos.x = lerp(pos.x,pos_camera_moving.x, lerp_ramp_up_value)
		
	else:
		pos.y = lerp(pos.y, 0.0, delta * 3.0)
		pos.x = lerp(pos.x, 0.0, delta * 3.0)
		ramp_up_on_move = 0.01
	return pos

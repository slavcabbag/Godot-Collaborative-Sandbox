extends CharacterBody3D

# Custom speeds
# (VELOCITY): affects when not moving at all and in air
# (SPEED COUNTER): affects only when moving, speed_counter gradually increases as you move


# v Change these at your own risk v / Don't change
var moving = false # is a direction being pressed (w,s,a,d)
var exponential_speed = 1.0 # Initial Speed 
var speed_counter = 0.0 # Initial Speed
var Speed_Limit = 0.0 # Speed Limit switches between Sprint and Walking Speed Limits


#Medium Danger if changed / can experiment
const EXPONENTIAL_RATE = 0.1 # How fast speed_counter grows
# Used In: speed_counter += EXPONENTIAL_RATE
const EXPONENTIAL_LIMIT = 0.5 # Max that the exponential can go
const SPEED_COUNTER_DECELERATE = 7.0 # How fast the exponential rate decreases (SPEED COUNTER)
const DECELERATION_SPEED = 1.0 # How fast the speed decreases when not holding a direction (INCREASES INERTIA) (VELOCITY)
const WALK_EXPONENTIAL_RATE_REDUCER = 0.5 # a little tweaking number for walk speed decrease 
# Used In: speed_counter += EXPONENTIAL_RATE * WALK_EXPONENTIAL_RATE_REDUCER [In walk part of sprint code] 

#Change Self explanatory, have fun
const EXPONENTIAL_WALK_SPEED = 2.0 # Speed when Shift is NOT held
const SPRINT_SPEED_LIMIT = 12.5 # SPRINT_SPEED_LIMIT is max players speed can go while SPRINTING
const WALK_SPEED_LIMIT = 3.5 # WALK_SPEED_LIMIT is max players speed can go while WALKING
# CHANGING ONLY CHANGES START VALUE
var Fast_Sprint_Inertia = 3.5 # How much drag/inertia you will have when you are at 
# I made it so Inertia gets lower the less your speed is so its not rigid
# Slows your turns at high speeds 
#speeds higher than FAST_SPEED
const FAST_SPEED = 7.0 # How fast you have to go before being affected by inertia

var speed

const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.0018
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 9.8

# bob variables
const BOB_FREQUENCY = 2.0
const BOB_AMPLITUDE = 0.08
var t_bob = 0.0 # determine how far along the sine wave we are

# FOV Variables
const BASE_FOV = 75.0
const FOV_CHANGE = 1.5

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
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))

func _physics_process(delta):
	
	
	 
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Reset Speed_Counter on Sprint Pressed
	if Input.is_action_just_pressed("Sprint"):
		speed_counter = 0.1
	# Handle Sprint.
	if Input.is_action_pressed("Sprint"):
		Speed_Limit = SPRINT_SPEED_LIMIT 
		speed = SPRINT_SPEED_LIMIT
		
		# While Sprinting + Moving, accelerate to SPEED_LIMIT at a rate of EXPONENTIAL_RATE
		if moving == true:
			#Custom
			var clamped_exponential_speed 
			var clamped_speed_counter
			clamped_exponential_speed = clamp(speed/2.0 + speed_counter/5.0 * exponential_speed, 0.0, 10.0) 
			clamped_speed_counter = clamp(speed_counter, 0.0, EXPONENTIAL_LIMIT) #Max that the exponential can go
			speed_counter += EXPONENTIAL_RATE #how fast speed_counter grows 
			exponential_speed = speed/2 + speed_counter/5.0 * clamped_exponential_speed
			exponential_speed = clamp(exponential_speed,EXPONENTIAL_WALK_SPEED,Speed_Limit) #SPEED_LIMIT is max players speed can go 
			#^block of code that has to be kept together
	
	# If walking, set speed to EXPONENTIAL_WALK_SPEED
	else:
		
		
		
		speed = WALK_SPEED_LIMIT
		Speed_Limit = WALK_SPEED_LIMIT
		#Custom
		var clamped_exponential_speed 
		var clamped_speed_counter
		clamped_exponential_speed = clamp(speed/2.0 + speed_counter/5.0 * exponential_speed, 0.0, 10.0) 
		clamped_speed_counter = clamp(speed_counter, 0.0, EXPONENTIAL_LIMIT) #Max that the exponential can go
		speed_counter += EXPONENTIAL_RATE * WALK_EXPONENTIAL_RATE_REDUCER #how fast speed_counter grows * a little tweaking number for walk
		exponential_speed = speed/2 + speed_counter/5.0 * clamped_exponential_speed
		exponential_speed = clamp(exponential_speed,EXPONENTIAL_WALK_SPEED,Speed_Limit) #SPEED_LIMIT is max players speed can go 
		#^block of code that has to be kept together
		
	

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("Move_Left", "Move_Right", "Move_Forward", "Move_Backward")
	# Change direction from head, not body of character
	# (moves where your camera faces)
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	label.add_theme_color_override("font_color",Color(1.0,1.0,1.0,1.0))
	if is_on_floor():
		
		if direction:
			moving = true
			

			#Slow your turns at high speeds
			#----------CURRENT WORK ON
			if exponential_speed > FAST_SPEED:
				velocity.x = lerp(velocity.x, direction.x * exponential_speed, delta * Fast_Sprint_Inertia)
				velocity.z = lerp(velocity.z, direction.z * exponential_speed, delta * Fast_Sprint_Inertia)
			else:
				
				velocity.x = direction.x * exponential_speed 
				velocity.z = direction.z * exponential_speed  
			label.add_theme_color_override("font_color",Color(0.5,0.1,0.5,1.0))
			
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
			+ "\n \n speed_counter" \
			+ "\n \n " + str(moving)

	# head bob
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)

	# FOV
	var velocity_clamped = clamp(velocity.length(), 0.5, SPRINT_SPEED_LIMIT * 2)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)
	

	move_and_slide()

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQUENCY) * BOB_AMPLITUDE
	pos.x = cos(time * BOB_FREQUENCY/2) * BOB_AMPLITUDE
	return pos
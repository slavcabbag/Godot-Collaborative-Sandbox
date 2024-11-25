extends Node3D

#var gun_manager
@onready var player = $"../../../.."
@onready var camera = $"../.."

var last_camera_position

func _ready():
	last_camera_position = player.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#if player == null:
		#var current = self
		#while current.name != "Player":
			#current = current.get_parent()
		#player = current
		#camera = player.get_child(2).get_child(0)
		#last_camera_position = player.position
	
	
	
	
	if name == "Gun Attach Point":
		global_position = lerp(global_position + Vector3(0,0.27,0),last_camera_position, delta*10)
		last_camera_position = player.global_position;

func _process(delta):
	if name == "Gun Attach Point3":
		global_position = lerp(global_position,last_camera_position + Vector3(0,0.7,0), delta*11)
		last_camera_position = player.global_position;

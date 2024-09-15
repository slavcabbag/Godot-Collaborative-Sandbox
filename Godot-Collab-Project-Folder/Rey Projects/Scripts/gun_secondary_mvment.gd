extends Node3D

@onready var player = $"../../.."

@onready var camera = $".."
var last_camera_position

# Called when the node enters the scene tree for the first time.
func _ready():
	last_camera_position = player.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if name == "Gun Attach Point":
		global_position = lerp(global_position+ Vector3(0,0.27,0),last_camera_position, delta*10)
		last_camera_position = player.global_position;

func _process(delta):
	if name == "Gun Attach Point3":
		global_position = lerp(global_position+ Vector3(0,0.27,0),last_camera_position, delta*15)
		last_camera_position = player.global_position;

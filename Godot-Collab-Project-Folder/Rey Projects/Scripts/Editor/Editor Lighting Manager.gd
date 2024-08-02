@tool
extends Node3D

@onready var directional_light_3d = $"../../DirectionalLight3D"
@onready var world_environment = $"../../WorldEnvironment"

var sky_x = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	if Engine.is_editor_hint():
		directional_light_3d.light_energy = 3

	if !Engine.is_editor_hint():
		directional_light_3d.light_energy = 1
func _process(delta):
	if !Engine.is_editor_hint():
		if directional_light_3d.light_energy >= 0.55:
			directional_light_3d.light_energy = lerp(directional_light_3d.light_energy, 2.0, delta * 0.1)
		sky_x += 0.01
		world_environment.environment.set_sky_rotation(Vector3(0,5,3.01))
		
		


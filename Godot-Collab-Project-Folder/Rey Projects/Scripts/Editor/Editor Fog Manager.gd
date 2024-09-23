@tool
extends Node3D

@onready var world_environment = $"../../WorldEnvironment"


var scene_environment
func _ready():
	if Engine.is_editor_hint():
		world_environment.environment.volumetric_fog_enabled = false

	if !Engine.is_editor_hint():
		world_environment.environment.volumetric_fog_enabled = true

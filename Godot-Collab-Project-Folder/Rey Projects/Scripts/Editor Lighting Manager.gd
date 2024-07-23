@tool
extends Node3D

@onready var directional_light_3d = $"../../DirectionalLight3D"

# Called when the node enters the scene tree for the first time.
func _ready():
	if Engine.is_editor_hint():
		directional_light_3d.light_energy = 3

	if !Engine.is_editor_hint():
		directional_light_3d.light_energy = 1


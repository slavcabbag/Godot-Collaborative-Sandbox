extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	var randnum = randi_range(0,20) * 5
	
	rotation = Vector3(0,randnum,0)
	

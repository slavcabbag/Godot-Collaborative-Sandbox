extends StaticBody3D

@export var size_radius = 2.0
var player = null
var templabel = null
@onready var area_3d = $Area3D

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("./CollisionShape3D").get_shape().set_radius(size_radius)
	get_node("./CollisionShape3D/MeshInstance3D").get_mesh().set_bottom_radius(size_radius*1.3)
	get_node("./CollisionShape3D/MeshInstance3D").get_mesh().set_top_radius(size_radius)
	get_node("./Area3D/CollisionShape3D").get_shape().set_radius(size_radius+size_radius*0.2)
	#player = get_node(player_path)
	player = get_node("/root/World/Player")
	templabel = player.get_node("./Head/Camera3D/TempLabel")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	templabel.text = str(player.global_transform.origin.y > global_transform.origin.y -2.2)
	if Engine.get_frames_drawn() % 2 == 1:
		var go_time = false
		for physics_body in area_3d.get_overlapping_bodies():
			templabel.text += "\n  " + str(physics_body)
			if physics_body.name == "Player":
				go_time = true
			else: go_time = false
		if go_time:
			get_node("CollisionShape3D").disabled = true
			get_node("CollisionShape3D/MeshInstance3D").visible = false
		else:
			get_node("CollisionShape3D").disabled = false
			get_node("CollisionShape3D/MeshInstance3D").visible = true

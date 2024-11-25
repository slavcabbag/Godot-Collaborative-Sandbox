extends Node3D
@onready var pickup_area = $Area3D

func _process(delta):
	if Engine.get_frames_drawn() % 2 == 1:
		for physics_body in pickup_area.get_overlapping_bodies():
			if physics_body.name == "Player":
				physics_body.get_child(2).get_child(0).get_child(3).extra_gun_pickup("double guns")
				queue_free()
				#it would be tedious to go from player script to grab information on guns
				#instead I can cut out going from player script to gun manager script and
				#just call a function directly at gun manager script
				

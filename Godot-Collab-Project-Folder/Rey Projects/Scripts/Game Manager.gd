extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func _physics_process(delta):
	# exit out of game
	if Input.is_action_just_pressed("Menu-Escape"):
		queue_free()
		get_tree().quit()





extends Node3D

@onready var gravestone_roof_2 = $"gravestone-roof2"

# Called when the node enters the scene tree for the first time.
func _ready():
	Get_Graves()

func Get_Graves():
	var graves = get_children()
	# Would sometimes pick the grave as the random and have no gravestone
	# Removing it from the list makes it so it doesn't get picked
	
	var picked_grave = graves.pick_random()
	picked_grave.visible = true
	for grave in graves:
		if grave != picked_grave && grave.name != "grave2":
			grave.queue_free()
	

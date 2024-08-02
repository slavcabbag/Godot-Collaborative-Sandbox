@tool
extends Label3D


# Called when the node enters the scene tree for the first time.
func _ready():
	# Tada! setting color for 3dLabels because it just cant be easy can it
	set_modulate(Color(1,1,1,1))
	alpha_cut = Label3D.ALPHA_CUT_HASH

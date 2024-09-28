@tool
extends Node3D

@onready var _1911 = $"../GunManager/Gun Attach Point/1911"
@onready var tt_handgun = $"../GunManager/Gun Attach Point/TT Handgun"
@onready var top_1911 = $"../GunManager/Gun Attach Point/Gun Attach Point3/1911"
@onready var top_tt_handgun = $"../GunManager/Gun Attach Point/Gun Attach Point3/TT Handgun"



#Aligns the guns to this object

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	
	#ROTATE GUNS TOWARD POINT (IDK I HAD TO CHANGE MODELS ORIGINS AND LINE EM UP WITH THE RAYCAST3D)
	#I ALSO HAD TO DO SOME WIERD RADIAN AND COMPUTER SCIENCE WIZARDRY TO GET IT TO WORK RIGHT
	# THIS MUSIC CARRIED ME (Monster Hunter: World - Private Suite (Extended))

	var guns = [_1911,tt_handgun] 
	var topguns = [top_1911,top_tt_handgun]
	if Engine.is_editor_hint():
		for gun in guns:
			if gun != top_1911 || top_tt_handgun:
				gun.look_at(Vector3(global_position.x,global_position.y,global_position.z))
				gun.rotation = Vector3(gun.rotation.x-3.14,gun.rotation.y,gun.rotation.z-3.14)
		for topgun in topguns:
				topgun.look_at(Vector3(global_position.x,global_position.y,global_position.z))
				topgun.rotation = Vector3(topgun.rotation.x,topgun.rotation.y,topgun.rotation.z-3.14)
	if !Engine.is_editor_hint():
		for gun in guns:
			if gun != top_1911 || top_tt_handgun:
				gun.look_at(Vector3(global_position.x,global_position.y,global_position.z))
				gun.rotation = Vector3(gun.rotation.x-3.14,gun.rotation.y,gun.rotation.z-3.14)
		for topgun in topguns:
				topgun.look_at(Vector3(global_position.x,global_position.y,global_position.z))
				topgun.rotation = Vector3(topgun.rotation.x,topgun.rotation.y,topgun.rotation.z-3.14)
		

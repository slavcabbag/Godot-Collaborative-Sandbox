extends Node3D
@onready var player = $"../../.."

@onready var _1911 = $"Gun Attach Point/1911"
@onready var tt_handgun = $"Gun Attach Point/TT Handgun"
@onready var top_1911 = $"Gun Attach Point/Gun Attach Point3/1911"
@onready var top_tt_handgun = $"Gun Attach Point/Gun Attach Point3/TT Handgun"


@onready var handgun_anim = $"Gun Attach Point/TT Handgun/TT Handgun/AnimationPlayer"
@onready var anim_1911 = $"Gun Attach Point/1911/1911/AnimationPlayer"
@onready var top_anim_1911 = $"Gun Attach Point/Gun Attach Point3/1911/1911/AnimationPlayer"
@onready var top_handgun_anim = $"Gun Attach Point/Gun Attach Point3/TT Handgun/TT Handgun/AnimationPlayer"

@onready var gun_barrel_1911 = $"Gun Attach Point/1911/1911/RayCast3D"
@onready var gun_barrel_handgun = $"Gun Attach Point/TT Handgun/TT Handgun/RayCast3D"
@onready var topgun_barrel_1911 = $"Gun Attach Point/Gun Attach Point3/1911/1911/RayCast3D"
@onready var topgun_barrel_handgun = $"Gun Attach Point/Gun Attach Point3/TT Handgun/TT Handgun/RayCast3D"

var bullet = load("res://Rey Projects/Scenes/bullet.tscn")
@onready var player_aim = $PlayerAim
@onready var gun_look_point = $"../GunLookPoint"
var distance



var two_fire_burst = false
# Called when the node enters the scene tree for the first time.
func _ready():
	player_aim.add_exception($"../../..") #exception is player collider

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	distance = player_aim.get_collision_point().distance_to(get_parent().get_parent().position)

	
	
	player_aim.force_raycast_update()
	if player_aim.is_colliding():
		gun_look_point.global_position = lerp(gun_look_point.global_position,player_aim.get_collision_point(), delta*11) 
	var instance
	if two_fire_burst:
			
		if Input.is_action_pressed("Shoot"):
			if !handgun_anim.is_playing():
				
				await get_tree().create_timer(0.2).timeout
				
				handgun_anim.play("TT_Handgun_Shoot")
				
			if !anim_1911.is_playing():
				anim_1911.play("1911_shoot")
				gun_shoot(gun_barrel_1911)
				gun_shoot(gun_barrel_handgun)
				await get_tree().create_timer(0.2).timeout
				top_handgun_anim.play("TT_Handgun_Shoot")
				gun_shoot(topgun_barrel_handgun)
				top_anim_1911.play("1911_shoot")
				gun_shoot(topgun_barrel_1911)
	else:
		
		if Input.is_action_pressed("Shoot"):
			if !handgun_anim.is_playing():
				await get_tree().create_timer(0.001).timeout
				handgun_anim.play("TT_Handgun_Shoot")
				gun_shoot(gun_barrel_handgun)
			if !anim_1911.is_playing():
				anim_1911.play("1911_shoot")
				gun_shoot(gun_barrel_1911)
				
				await get_tree().create_timer(0.07).timeout
				top_handgun_anim.play("TT_Handgun_Shoot")
				gun_shoot(topgun_barrel_handgun)
				top_anim_1911.play("1911_shoot")
				gun_shoot(topgun_barrel_1911)
				


func gun_shoot(gun):
	var instance
	instance = bullet.instantiate()
	instance.position = gun.global_position
	instance.transform.basis = gun.global_transform.basis
	get_parent().get_parent().get_parent().get_parent().add_child(instance)

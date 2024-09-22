extends Node3D
@onready var player = $"../../.."

@onready var handgun_anim = $"Gun Attach Point/TT Handgun/AnimationPlayer"
@onready var anim_1911 = $"Gun Attach Point/1911/AnimationPlayer"
@onready var top_anim_1911 = $"Gun Attach Point/Gun Attach Point3/1911/AnimationPlayer"
@onready var top_handgun_anim = $"Gun Attach Point/Gun Attach Point3/TT Handgun/AnimationPlayer"
@onready var gun_barrel_1911 = $"Gun Attach Point/1911/RayCast3D"
@onready var gun_barrel_handgun = $"Gun Attach Point/TT Handgun/RayCast3D"
@onready var topgun_barrel_1911 = $"Gun Attach Point/Gun Attach Point3/1911/RayCast3D"
@onready var topgun_barrel_handgun = $"Gun Attach Point/Gun Attach Point3/TT Handgun/RayCast3D"

var bullet = load("res://Rey Projects/Scenes/bullet.tscn")

var two_fire_burst = false
# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    var instance
    if two_fire_burst:
            
        if Input.is_action_pressed("Shoot"):
            if !handgun_anim.is_playing():
                await get_tree().create_timer(0.2).timeout
                handgun_anim.play("TT_Handgun_Shoot")
                
            if !anim_1911.is_playing():
                anim_1911.play("1911_shoot")
                
                
                await get_tree().create_timer(0.2).timeout
                top_handgun_anim.play("TT_Handgun_Shoot")
                top_anim_1911.play("1911_shoot")
    else:
        
        if Input.is_action_pressed("Shoot"):
            if !handgun_anim.is_playing():
                await get_tree().create_timer(0.01).timeout
                handgun_anim.play("TT_Handgun_Shoot")
                instance = bullet.instantiate()
                instance.position = gun_barrel_handgun.global_position
                instance.transform.basis = gun_barrel_handgun.global_transform.basis
                get_parent().get_parent().get_parent().get_parent().add_child(instance)
            if !anim_1911.is_playing():
                anim_1911.play("1911_shoot")
                instance = bullet.instantiate()
                instance.position = gun_barrel_1911.global_position
                instance.transform.basis = gun_barrel_1911.global_transform.basis
                get_parent().get_parent().get_parent().get_parent().add_child(instance)
                
                await get_tree().create_timer(0.04).timeout
                top_handgun_anim.play("TT_Handgun_Shoot")
                instance = bullet.instantiate()
                instance.position = topgun_barrel_handgun.global_position
                instance.transform.basis = topgun_barrel_handgun.global_transform.basis
                get_parent().get_parent().get_parent().get_parent().add_child(instance)
                top_anim_1911.play("1911_shoot")
                instance = bullet.instantiate()
                instance.position = topgun_barrel_1911.global_position
                instance.transform.basis = topgun_barrel_1911.global_transform.basis
                get_parent().get_parent().get_parent().get_parent().add_child(instance)

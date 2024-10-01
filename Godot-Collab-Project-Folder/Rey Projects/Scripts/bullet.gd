extends Node3D


const SPEED = 40.0
@onready var mesh = $MeshInstance3D
@onready var ray = $RayCast3D
@onready var particles = $GPUParticles3D

var switch = 1



# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += transform.basis * Vector3(0,0,-SPEED) * delta 
	if ray.is_colliding():
		var collider = ray.get_collider() 
		mesh.visible = false
		particles.emitting = true
		ray.enabled = false		
		if ray.get_collider().is_in_group("enemy"):
			ray.get_collider().hit()

		await get_tree().create_timer(1.0).timeout
		queue_free()

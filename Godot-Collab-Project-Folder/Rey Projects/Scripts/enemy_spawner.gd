extends Node3D
@onready var spawns = $"../../Map/Spawns"
@onready var navigation_region_3d = $"../../Map/NavigationRegion3D"

var zombro = load("res://Rey Projects/Scenes/Characters/zombro_the_i.tscn")
var instance

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _get_random_child(parent_node):
	var random_id = randi() % parent_node.get_child_count()
	return parent_node.get_child(random_id)

func _on_zombie_spawn_timer_timeout():
	var spawn_point = _get_random_child(spawns).global_position
	instance = zombro.instantiate()
	instance.position = spawn_point
	navigation_region_3d.add_child(instance)

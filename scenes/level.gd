extends Node3D

@export var log_scene = preload("res://scenes/woodlog.tscn")
@export var log_count = 50
@export var spawn_area = Vector3(200, 0, 200)

func _ready():
	spawn_logs()
	
func spawn_logs():
	for i in range(log_count):
		var log_instance = log_scene.instantiate()
		add_child(log_instance)
		var random_position = Vector3(
			randf_range(-spawn_area.x / 2, spawn_area.x / 2),
			0,
			randf_range(-spawn_area.z / 2, spawn_area.z / 2)
		)
		
		log_instance.call_deferred("set_global_position", random_position)
		

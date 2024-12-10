extends Node3D

@export var rotation_speed = 30.0  # Degrees per second
@onready var camera_pivot = $CameraPivot  # Adjust the path as needed

func _process(delta):
	if camera_pivot:
		camera_pivot.rotation_degrees.y += rotation_speed * delta

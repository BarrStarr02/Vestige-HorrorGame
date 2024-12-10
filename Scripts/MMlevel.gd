extends Node3D

@export var rotation_speed = 20.0 
@onready var camera_pivot = $CameraPivot  

func _process(delta):
	if camera_pivot:
		camera_pivot.rotation_degrees.y += rotation_speed * delta

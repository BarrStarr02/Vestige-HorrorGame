extends Camera3D

@onready var camera_3d = $"."

# Called when the node enters the scene tree for the first time.
func _ready():
	$Camera.make_current()

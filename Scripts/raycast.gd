extends RayCast3D

var int_text : Control  # Reference to the UI for showing interact text
var interactable : Node = null  # The object that we are interacting with

func _ready():
	int_text = get_node("/root/" + get_tree().current_scene.name + "/UI/interact text")

func _process(_delta):
	if is_colliding():
		var hit = get_collider()
		if hit != null and hit.has_method("interact"):
			int_text.visible = true  # Show the interact text
			if Input.is_action_just_pressed("interact"):
				hit.interact()  # Call the interact method of the object
		else:
			int_text.visible = false  # Hide the interact text if no valid interaction
	else:
		int_text.visible = false  # Hide interact text if no collision

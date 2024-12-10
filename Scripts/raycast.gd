extends RayCast3D

var int_text : Control  
var interactable : Node = null  

func _ready():
	int_text = get_node("/root/" + get_tree().current_scene.name + "/UI/interact text")

func _process(_delta):
	if is_colliding():
		var hit = get_collider()
		if hit != null and hit.has_method("interact"):
			int_text.visible = true  
			if Input.is_action_just_pressed("interact"):
				hit.interact()  
		else:
			int_text.visible = false  
	else:
		int_text.visible = false  

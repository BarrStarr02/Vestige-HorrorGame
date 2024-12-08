extends RayCast3D

var int_text : Control  # Reference to the UI for showing interact text
var interactable : Node = null  # Reference to the interactable object (log or campfire)
var player : Node3D  # Reference to the player character
var max_interact_distance : float = 5.0 # Max distance at which the player can interact

func _ready():
	# Initialize the UI interact text node
	int_text = get_node("/root/" + get_tree().current_scene.name + "/UI/interact text")
	# Get the player node reference
	player = get_node("/root/level/Player")  # Adjust path if needed

# Called every frame to check if the raycast is colliding with an object
func _process(_delta):
	# Check if the raycast is colliding with something
	if is_colliding():
		var hit = get_collider()  # Get the collider that the raycast hit

		# Check for log interaction
		if hit.is_in_group("pickup_log"):
			int_text.visible = true  # Show interact text
			interactable = hit
			if Input.is_action_just_pressed("interact"):
				interactable.interact_with_log()  # Call log interaction
				
				if player != null:
					player.collected_logs += 1
					print("logs collected! Total logs: ", player.collected_logs)
				interactable = null
				

		# Check for campfire interaction
		elif hit.is_in_group("campfire"):
			int_text.visible = true  # Show interact text
			interactable = hit
			# If the interact button is pressed, add fuel to the fire
			if Input.is_action_just_pressed("interact"):
				interactable.add_fuel()  # Add fuel to the fire
				print("Interacted with the campfire.")
				interactable = null
		else:
			int_text.visible = false  # Hide interact text for other objects
	else:
		int_text.visible = false  # Hide interact text if no collision

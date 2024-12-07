extends RayCast3D

var int_text : Control  # Reference to the UI for showing interact text
var interactable : Node = null  # Reference to the interactable object (log or campfire)
var player : Node3D  # Reference to the player character
var max_interact_distance : float = 5.0  # Max distance at which the player can interact

func _ready():
	# Initialize the UI interact text node
	int_text = get_node("/root/" + get_tree().current_scene.name + "/UI/interact text")
	# Get the player node reference
	player = get_node("/root/level/player")  # Adjust path if needed

# Called every frame to check if the raycast is colliding with an object
func _process(_delta):
	# Check if the raycast is colliding with something
	if is_colliding():
		var hit = get_collider()  # Get the collider that the raycast hit
		# Check if the collider is a log object (part of the "pickup_log" group)
		if hit and hit.is_in_group("pickup_log"):
			int_text.visible = true  # Show interact text
			interactable = hit  # Set the interactable object to the log that was hit
			if Input.is_action_just_pressed("interact"):
				# If the interact button is pressed, call interact_with_log() on the log
				interactable.interact_with_log()  # Call the method on the log
				interactable = null  # Clear the interactable after interacting
		# Check if the collider is the campfire (part of the "campfire" group)
		elif hit.is_in_group("campfire"):
			int_text.visible = true  # Show interact text
			interactable = hit  # Set the interactable object to the campfire
			# Check if the player is close enough to interact with the campfire
			if player.position.distance_to(hit.position) <= max_interact_distance:
				# If the interact button is pressed, interact with the campfire (add fuel)
				if Input.is_action_just_pressed("interact"):
					interactable.add_fuel()  # Call the method on the campfire
					print("Interacted with the campfire.")
					interactable = null  # Clear the interactable after interacting
			else:
				# Display message if the player is too far to interact
				int_text.text = "You are too far from the campfire!"
		else:
			int_text.visible = false  # Hide the interact text if not colliding with a log or campfire
	else:
		int_text.visible = false  # Hide the interact text if no collision is detected

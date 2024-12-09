extends Node3D

@export var fire_decay_rate = 1.0  # Rate of fire decay per second
@export var fire_increase_amount = 10  # Amount to increase fire energy when a log is added
var fire_slider : Slider  # Reference to the fire slider
var on_DepositArea_body_entered = false
var is_fire_active = true  # Flag to track if the fire is still active

# Reference to the player
var player : Node3D

func _ready():
	# Attempt to locate the fire slider (in the UI)
	add_to_group("campfire")
	var current_scene = get_tree().current_scene
	fire_slider = current_scene.get_node_or_null("UI/fire_stuff/fire_slider")

	# Get the player node (adjust path as needed based on your scene structure)
	player = get_node("/root/level/Player")  # Use the correct path to the player node

	if fire_slider == null:
		print("Error: Fire slider not found!")
	else:
		fire_slider.value = fire_slider.max_value  # Initialize slider to full (fire is on)
		print("Fire slider initialized!")

# Update the fire decay logic
func _process(delta):
	if fire_slider == null:
		return  # Skip if slider not found
	

	# If the fire is active, decrease the slider value over time
	if is_fire_active:
		fire_slider.value -= fire_decay_rate * delta
		if fire_slider.value <= fire_slider.min_value:
			fire_slider.value = fire_slider.min_value
			visible = false  # Hide the fire (or maybe change to a "dormant" state)
			print("The fire has gone out!")
			is_fire_active = false  # Stop the fire from decaying further

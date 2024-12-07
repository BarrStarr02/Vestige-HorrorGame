extends Node3D

@export var fire_decay_rate = 5.0  # Rate of fire decay per second
@export var fire_increase_amount = 10  # Amount to increase fire energy when a log is added
var fire_slider : Slider  # Reference to the fire slider

var is_fire_active = true  # Flag to track if the fire is still active

func _ready():
	# Attempt to locate the fire slider (in the UI)
	add_to_group("campfire")
	var current_scene = get_tree().current_scene
	fire_slider = current_scene.get_node_or_null("UI/fire_stuff/fire_slider")

	if fire_slider == null:
		print("Error: Fire slider not found!")
	else:
		fire_slider.value = fire_slider.max_value  # Initialize slider to full (fire is on)

# Update the fire decay logic and interact logic
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

# Function to interact with the campfire (add fuel)
func interact():
	if Input.is_action_just_pressed("interact"):
		# Function to add fuel to the fire (log added)
		if fire_slider:
			# Add fuel only if the player has a log
			if get_parent().has_log:
				fire_slider.value += fire_increase_amount  # Add fuel to the fire
				fire_slider.value = min(fire_slider.value, fire_slider.max_value)  # Ensure it doesn't exceed max value
				print("Log added to the fire!")  # Debugging message
				get_parent().has_log = false  # Player no longer has a log after adding fuel

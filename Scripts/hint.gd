extends Control

@onready var label : Label = $Label  # The Label node as a child of Control
@onready var timer : Timer = $Timer  # The Timer node as a child of Control

# Function to make the label disappear after a few seconds
func fade_out_label(duration: float):
	# Ensure the label is visible and fully opaque
	label.visible = true
	label.modulate.a = 1.0  # Reset the alpha to full opacity

	# Set up the timer duration and start it
	timer.wait_time = duration  # Set the duration to wait for
	timer.start()  # Start the timer

	# Wait for the timer to complete
	await timer.timeout  # Wait for the timer's timeout signal

	# Fade out the label by setting its alpha to 0 (fully transparent)
	label.modulate.a = 0  # Set the alpha to 0 for full transparency

	# Optionally, hide the label completely after it fades
	label.visible = false  # Hide the label after fading

# Example usage: call this in the _ready function or based on an event
func _ready():
	# Start the fade-out effect with a duration of 5 seconds
	fade_out_label(5.0)

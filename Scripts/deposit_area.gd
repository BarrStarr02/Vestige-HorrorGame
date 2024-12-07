extends Area3D

var player : CharacterBody3D  # Reference to the player node
@export var energy_add_amount = 5.0  # Amount to increase fire energy when a log is deposited
var fire_slider : Slider  # Reference to the fire slider to update fuel

func _ready():
	add_to_group("deposit_area")
	# Connect the body_entered signal to the method that will handle it
	connect("body_entered", Callable(self, "_on_DepositArea_body_entered"))

# This method will be called when a body enters the area
func _on_DepositArea_body_entered(body):
	if body.is_in_group("player"):  # Ensure it is the player
		player = body  # Store a reference to the player
		print("Player entered deposit area")

# This function will be called in _process when the player is close to the area and presses interact
func _process(_delta):
	if player and player.has_log:  # Ensure the player has a log and is close
		if Input.is_action_just_pressed("interact"):  # Check if the interact button is pressed
			deposit_log_into_fire()  # Deposit the log into the fire

# This function adds the log to the fire slider
func deposit_log_into_fire():
	if fire_slider:
		fire_slider.value += energy_add_amount  # Increase fire slider value
		fire_slider.value = min(fire_slider.value, fire_slider.max_value)  # Ensure it doesn't exceed max
		player.has_log = false  # Reset player's log status
		print("Log added to the fire!")

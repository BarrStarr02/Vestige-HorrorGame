extends StaticBody3D

@export var energy_add_amount = 5.0
var fire_energy : Slider  # Reference to the fire slider
var player : CharacterBody3D  # Reference to the player to check if they're in range

func _ready():
	# Attempt to locate the fire slider (in the UI)
	fire_energy = get_node_or_null("/root/" + get_tree().current_scene.name + "/UI/fire_stuff/fire_slider")
	
	# Add the log to the pickup_log group so the raycast can detect it
	add_to_group("pickup_log")
	
	# Get the player node (adjust path as needed based on your scene structure)
	player = get_node("/root/level/Player")  # Use the correct path to the player node

func interact_with_log():
	# Always allow the log to be picked up
	if fire_energy:
		# Queue the log for removal (so it disappears when picked up)
		queue_free()
		
		# Check if the player is in the deposit area before adding fuel
		if player.is_in_group("deposit_area"):
			# If in the deposit area, add fuel to the fire
			fire_energy.value += energy_add_amount  # Add fuel to the fire
			fire_energy.value = min(fire_energy.value, fire_energy.max_value)  # Ensure it doesn't exceed max value
			print("Log added to the fire!")  # Debugging message
		else:
			# If not in the deposit area, just print a message
			print("You picked up a log, but you're not in the deposit area to add it to the fire.")

			print("You picked up a log, but you're not in the deposit area to add it to the fire.")

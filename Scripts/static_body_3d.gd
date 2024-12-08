extends StaticBody3D

@export var energy_add_amount = 10.0
var fire_slider : Slider  # Reference to fire slider
var player : CharacterBody3D

func _ready():
	fire_slider = get_node("/root/level/UI/fire_stuff/fire_slider")
	player = get_node("/root/level/Player")  # Adjust the player node path as needed

func interact():
	if fire_slider and player.collected_logs > 0:
		# Add energy to the fire slider
		fire_slider.value += energy_add_amount
		fire_slider.value = min(fire_slider.value, fire_slider.max_value)
		
		# Decrement one log from the player's collected logs
		player.collected_logs -= 1
		print("Fire energy increased! Logs remaining: ", player.collected_logs)
	else:
		print("No logs to add to the fire.")

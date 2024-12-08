extends Node3D

@export var fire_energy : NodePath  # Path to the fire slider node
@export var energy_add_amount : int = 10

func _ready():
	add_to_group("player")
	# Ensure the StaticBody3D node exists and connect its signal
	var static_body = $MeshInstance3D/StaticBody3D
	if static_body:
		static_body.body_entered.connect(Callable(self, "_on_body_entered"))
	else:
		print("Error: StaticBody3D not found!")

func _on_body_entered(body: Node3D):
	if body.is_in_group("player"):  # Adjust to your player group name
		print("Player interacted with the button!")
		# Add your logic for updating fire energy or player logs here

func _process(_delta):
	if Input.is_action_just_pressed("interact"):
		var fire = get_node(fire_energy)
		if fire:
			fire.value += energy_add_amount
			fire.value = min(fire.value, fire.max_value)
			print("Fire energy increased!")

		var player = get_parent().get_node("Player")
		if player:
			player.collected_logs -= 1
			print("Logs remaining:", player.collected_logs)

		if player.collected_logs <= 0:
			set_process(false)  # Disable interaction if no logs left

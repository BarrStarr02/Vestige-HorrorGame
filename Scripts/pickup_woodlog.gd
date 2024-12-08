extends StaticBody3D

@export var energy_add_amount = 5.0

var player : CharacterBody3D

func _ready():
	player = get_node("/root/level/Player")
	add_to_group("pickup_log")

func interact():
	player.collected_logs += 1
	queue_free()
	print("Log collected!")
	print("your logs", player.collected_logs)

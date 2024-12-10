extends Node3D
const MAINMENUANIM = preload("res://scenes/mainmenuanim.tscn")
@export var fire_decay_rate = 3.0  
@export var fire_increase_amount = 10 
var fire_slider : Slider  
var on_DepositArea_body_entered = false
var is_fire_active = true  
var is_game_over = false


var player : Node3D

func game_over():
	if is_game_over:
		return
	is_game_over = true
	get_tree().change_scene_to_packed(MAINMENUANIM)
	

func _ready():
	add_to_group("campfire")
	var current_scene = get_tree().current_scene
	fire_slider = current_scene.get_node_or_null("UI/fire_stuff/fire_slider")

	
	player = get_node("/root/level/Player") 

	if fire_slider == null:
		print("Error: Fire slider not found!")
	else:
		fire_slider.value = fire_slider.max_value  
		print("Fire slider initialized!")


func _process(delta):
	if fire_slider == null:
		return 
	

	
	if is_fire_active:
		fire_slider.value -= fire_decay_rate * delta
		if fire_slider.value <= fire_slider.min_value:
			fire_slider.value = fire_slider.min_value
			visible = false 
			print("The fire has gone out!")
			is_fire_active = false  
			game_over()

extends CharacterBody3D

var ORIGINAL_SPEED
var SPEED = 3.0
var SPRINT_SPEED = 5.0
const JUMP_VELOCITY = 3.0
var sprint_slider
var sprint_drain_amount = 0.3
var sprint_refresh_amount = 0.2
var has_log = false
var interactable : Node = null

# Variables to track if the player is in the deposit area
var in_deposit_area = false

# Reference to the interact text UI
var int_text : Control  # Make sure this is properly referenced in _ready()

func pick_up_log():
	has_log = true

# Modify interact_with_fire to work when in the deposit area
func interact_with_fire(campfire: Node):
	if has_log and in_deposit_area:
		campfire.add_fuel()  # Add fuel to the fire
		has_log = false  # Log is consumed
		print("Log added to the fire!")  # Debug message

# Detecting when the player enters or exits the deposit area
func _on_body_entered(body: Node3D):
	if body.is_in_group("pickup_log"):
		interactable = body  # Detect log to pick up
	elif body.is_in_group("deposit_area"):  # Check if the player enters the deposit area
		in_deposit_area = true
		print("Player entered deposit area.")  # Debug message

func _on_body_exited(body: Node3D):
	if body.is_in_group("deposit_area"):  # Check if the player leaves the deposit area
		in_deposit_area = false
		print("Player exited deposit area.")  # Debug message

# _ready to initialize components like sprint slider, etc.
func _ready():
	add_to_group("player")
	ORIGINAL_SPEED = SPEED
	sprint_slider = get_node("/root/" + get_tree().current_scene.name + "/UI/sprint_slider")
	int_text = get_node("/root/" + get_tree().current_scene.name + "/UI/interact_text")  # Reference to interact text
	pass

# Handle input, movement, sprinting, and interactions
func _process(delta):
	if interactable and interactable.is_in_group("pickup_log"):
		if Input.is_action_just_pressed("interact"):
			interactable.interact_with_log()  # Call the log's interact method
			print("Player interacted with log.")  # Debug message
			interactable = null  # Clear interactable after interacting

	# Handle sprint logic
	if SPEED == SPRINT_SPEED:
		sprint_slider.value -= sprint_drain_amount * delta
		if sprint_slider.value == sprint_slider.min_value:
			SPEED = ORIGINAL_SPEED
	if SPEED != SPRINT_SPEED:
		if sprint_slider.value < sprint_slider.max_value:
			sprint_slider.value += sprint_refresh_amount * delta
		if sprint_slider.value == sprint_slider.max_value:
			sprint_slider.visible = false
	
	# Handle movement
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		if Input.is_action_just_pressed("sprint"):
			sprint_slider.visible = true
			SPEED = SPRINT_SPEED
		if Input.is_action_just_released("sprint"):
			SPEED = ORIGINAL_SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

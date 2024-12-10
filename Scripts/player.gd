extends CharacterBody3D

var ORIGINAL_SPEED
var SPEED = 3.0
var SPRINT_SPEED = 5.0
const JUMP_VELOCITY = 3.0
var sprint_slider
var sprint_drain_amount = 0.3
var sprint_refresh_amount = 0.5
var has_log = false
var interactable : Node = null  # Reference to the interactable object (log or campfire)
var fire_slider : Slider  # Reference to the fire slider
var in_deposit_area = false  # Track if the player is in the deposit area
var deposit_area : Area3D
var collected_logs = 0
var gravity: float = -9.8
# Called when the player enters the deposit area


# Called when the player leaves the deposit ar

# _ready to initialize components like sprint slider, etc.
func _ready():
	add_to_group("player")
	ORIGINAL_SPEED = SPEED
	sprint_slider = get_node("/root/" + get_tree().current_scene.name + "/UI/sprint_slider")
	fire_slider = get_node("/root/" + get_tree().current_scene.name + "/UI/fire_stuff/fire_slider")  # Reference to the fire slider
	pass

# Handle input, movement, sprinting, and interactions
func _process(delta):
	if is_on_floor() and Input.is_action_pressed("jump"):  # Default 'ui_accept' is the space bar
		velocity.y = JUMP_VELOCITY  # Apply jump velocity
	else:
		velocity.y += gravity * delta
		
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

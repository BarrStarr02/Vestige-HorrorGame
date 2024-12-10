extends CharacterBody3D
@onready var player = $"../../Player"


@onready var nav = $NavigationAgent3D
@onready var bigger_detector = $BiggerDetector
@onready var anim = $AnimationPlayer

var isChasing: bool = false
var isInBiggerDetector: bool = false
var randomPos: Vector3 = Vector3()
var wanderTimer: float = 60.0

var walkingSpeed: float = 4.0
var chasingSpeed: float = 8.0
var speed: float = walkingSpeed

func _ready():
	# Start wandering immediately
	set_new_random_position()
	player = get_node("/root/level/Player")

func _process(delta):
	# Handle state-based behavior
	if isChasing:
		chase_player()
		speed = chasingSpeed
		anim.play("Imported/RunImport")
	else:
		wander(delta)
		speed = walkingSpeed
		anim.play("Imported/WalkImport")

	# Move monster using NavigationAgent3D
	move_to_target(delta)

func move_to_target(delta):
	if not nav.is_target_reached():
		var direction = (nav.get_next_path_position() - global_position).normalized()
		velocity = velocity.lerp(direction * speed, delta * 10)
		move_and_slide()
	else:
		if not isChasing:
			set_new_random_position()

func chase_player():
	nav.target_position = player.global_position
	look_at(player.global_position)

func wander(delta):
	wanderTimer -= delta
	if wanderTimer <= 0 or nav.is_target_reached():
		set_new_random_position()
		wanderTimer = 60.0

func set_new_random_position():
	# Generate a new random position within bounds
	var random_x = randf_range(-100, 100)
	var random_z = randf_range(-100, 100)
	randomPos = Vector3(random_x, global_position.y, random_z)
	nav.target_position = randomPos

# Detector Signals
func _on_detector_body_entered(body):
	if body.is_in_group("player"):
		isChasing = true

func _on_detector_body_exited(body):
	if body.is_in_group("player"):
		isChasing = false
		set_new_random_position()

func _on_bigger_detector_body_entered(body):
	if body.is_in_group("player"):
		isInBiggerDetector = true
		isChasing = true

func _on_bigger_detector_body_exited(body):
	isInBiggerDetector = false
	isChasing = false

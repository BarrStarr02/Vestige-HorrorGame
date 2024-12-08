extends CharacterBody3D

@onready var player = get_tree().get_first_node_in_group("player")
@onready var isChasing: bool
@onready var isSearching: bool

@onready var radar: int = 0

var isInBiggerDetector : bool

@onready var nav := $NavigationAgent3D

@onready var randomPos = Vector3(randf_range(-75, 50), position.y, randf_range(-85, 20))

@onready var bigger_detector = $BiggerDetector

var lastPos
var hasSeen : bool

@onready var anim = $AnimationPlayer

@onready var walkingSpeed = 4
@onready var chasingSpeed = 8
@onready var speed = chasingSpeed
@onready var youDead := false
@onready var wanderTimer = 60.0

func _ready():
	wandering(0)
	


func chase():
	look_at(player.position)
	nav.target_position = player.global_position


func wandering(delta):
	look_at(global_transform.origin + velocity)
	hasSeen = false
	nav.target_position = randomPos
	if (abs(randomPos.x - global_position.x) <= 5 and abs(randomPos.z - global_position.z) <= 5) or wanderTimer <= 0:
		randomPos = Vector3(randf_range(player.global_position.x-40, player.global_position.x+40), position.y, randf_range(player.global_position.z-40, player.global_position.z+40))
		clamp(randomPos.x, -75, 50)
		clamp(randomPos.z, -85, 20)
		wanderTimer = 60.0
	wanderTimer-=delta

func _on_detector_body_entered(body):
	if body.is_in_group("player"):
		isChasing = true


func _on_detector_body_exited(body):
	if body.is_in_group("player"):
		lastPos = body.global_position
		randomPos = lastPos
		isChasing = false


func _on_bigger_detector_body_entered(body):
	isInBiggerDetector = true


func _on_bigger_detector_body_exited(body):
	isInBiggerDetector = false
	isChasing = false

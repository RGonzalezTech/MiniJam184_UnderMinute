class_name Player
extends CharacterBody3D

## The player controller for flight

## How quickly velocity changes (acceleration/deceleration)
const MOTION_SMOOTHING_SPEED : float = 3.5

## How quickly the player can turn it's mesh
const TURN_SPEED : float = 5.0

## Default force of Gravity
@export var GRAVITY : Vector3 = Vector3(0, -20, 0)

## Jump force when jumping
@export var JUMP_FORCE : float = 20.0

## THe node responsible for reporting whether we can jump
@onready var jump_manager : PlayerJumpManager = $PlayerJumpManager

## Movement Speed
@export var speed : float = 15.0

## Enabled when the game starts. Allows movement
@export var can_move : bool = false

## The Node3D that represents the player's relative "Forward" for input
@export var turn_rig : NodePath = ""
var _cam_rig : Node3D

func _ready() -> void:
	_cam_rig = get_node_or_null(turn_rig)
	# Ensure that the turn_rig node is correctly assigned and found.
	assert(_cam_rig, "Turn rig node not found. Please assign a Node3D to the 'turn_rig' export variable in the inspector.")
	
	GameManager.game_start.connect(_on_game_start)
	GameManager.game_end.connect(_on_game_end)

func _on_game_start() -> void:
	can_move = true

func _on_game_end() -> void:
	can_move = false

func _physics_process(delta: float) -> void:
	# Guard clause: prevent moving when unallowed
	if not can_move:
		return
	
	_apply_gravity(delta)
	
	# Get the desired movement direction based on input and camera orientation (world space, normalized).
	# This direction is where the player *intends* to move globally.
	var desired_world_direction : Vector3 = _get_desired_direction()
	
	# Update velocity and character orientation based on the desired world direction.
	_handle_acceleration(desired_world_direction, delta)
	_turn_mesh_for_velocity(delta)
	
	# Apply movement and handle collisions using CharacterBody3D's built-in function.
	move_and_slide()

func _input(event: InputEvent) -> void:
	if(event.is_action_released("jump") && jump_manager.jump()):
		# Do Jumping
		velocity.y = JUMP_FORCE

## If suspended in air, then apply a downward force (gravity).
func _apply_gravity(delta: float) -> void:
	if not is_on_floor(): # Apply gravity only if not on the floor
		velocity += GRAVITY * delta # Note: Standard practice is GRAVITY * delta

## Updates velocity to move in the 'desired_world_direction' and orients the player to face its movement.
func _handle_acceleration(desired_world_direction: Vector3, delta: float) -> void:
	var target_velocity : Vector3 = desired_world_direction * speed
	# Acceleration and deceleration.
	var smooth_velocity := velocity.lerp(target_velocity, delta * MOTION_SMOOTHING_SPEED)
	smooth_velocity.y = velocity.y # keep up/down
	velocity = smooth_velocity

## Returns the normalized world-space direction that the user wants to go,
## based on combined input and relative to the camera rig's "Forward" orientation.
## Returns Vector3.ZERO if there is no input.
func _get_desired_direction() -> Vector3:
	# Get the 2D input vector from movement actions.
	var input_dir_vector : Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	
	# If there's no significant input, return a zero vector immediately.
	if input_dir_vector.is_zero_approx():
		return Vector3.ZERO

	# Transform the 2D input into a 3D direction in the camera rig's local space.
	# Input Y (forward/backward) is mapped to Z, Input X (left/right) is mapped to X.
	var direction_in_camera_space : Vector3 = Vector3(input_dir_vector.x, 0, input_dir_vector.y)
	
	# Transform this camera-local direction into a world-space direction.
	var world_direction : Vector3 = _cam_rig.global_transform.basis * direction_in_camera_space
	
	# Return the normalized world-space direction.
	return world_direction.normalized()

## Uses the player velocity to turn the [%MeshPivot] towards the velocity direction
func _turn_mesh_for_velocity(delta: float) -> void:
	# Only turn if the player is actually moving
	if velocity.length_squared() <= 0.001:
		return
	
	# Automatic Turning: Face the direction of their current velocity.
	# Calculate the direction to look at, flattened on the Y axis to keep the character upright.
	var look_at_direction_flat : Vector3 = velocity.normalized()
	look_at_direction_flat.y = 0
#
	# Only proceed if the direction is still valid after flattening
	if look_at_direction_flat.length_squared() <= 0.001:
		return
	
	look_at_direction_flat = look_at_direction_flat.normalized() # Re-normalize after zeroing Y.
	var target_basis : Basis = Basis.looking_at(look_at_direction_flat, Vector3.UP)

	# Lerp the player's direction 
	%MeshPivot.transform.basis = %MeshPivot.transform.basis.slerp(target_basis, delta * TURN_SPEED)

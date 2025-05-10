class_name Player
extends CharacterBody3D

## Default force of Gravity
@export var GRAVITY : Vector3 = Vector3(0, -10, 0)

## Movement Speed
@export var speed : float = 5.0

func _physics_process(delta: float) -> void:
	_apply_gravity(delta)
	# Set desired velocity
	var direction = _get_desired_direction()
	_velocity_from_direction(direction)
	# Execute Move
	move_and_slide()

## If suspended in air, then apply a downward force
func _apply_gravity(delta: float) -> void:
	if not is_on_floor(): # Apply gravity only if not on the floor
		velocity += delta * GRAVITY

## Updates velocity to align with direction
func _velocity_from_direction(direction: Vector3) -> void:
	# Apply movement
	if direction:
		# Accel
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		# Decel
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

## Returns the direction that the user wants to go
## relative to the player's "Forward" orientation
func _get_desired_direction() -> Vector3:
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	return (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

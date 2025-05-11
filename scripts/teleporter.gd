class_name Teleporter
extends Area3D

## The [Node3D] to teleport to
@export var destination : NodePath = ""
var _destination : Node3D

func _ready() -> void:
	_destination = get_node_or_null(destination)
	assert(_destination, "Teleporter: Missing Destination")

	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	if not body.is_in_group("Player"):
		return # Ignore
	
	# Player entered: Move player
	body.global_position = _destination.global_position
	body.global_rotation = _destination.global_rotation

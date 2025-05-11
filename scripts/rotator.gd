class_name Rotator
extends Node3D

## Rotation Speed
@export var rotation_speed : float = 5.0

func _process(delta: float) -> void:
	var amount := rotation_speed * delta
	rotate_y(amount)

class_name MilestonePoint
extends Node3D

signal consumed

## Points worth
@export var points : int = 1

@onready var collision_area : Area3D = $CollArea
@onready var point_sound_player : AudioStreamPlayer = $PointSoundPlayer

func _ready() -> void:
	assert(collision_area, "MilestonePoint: Must have collision area")
	
	collision_area.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	if not body.is_in_group("Player"):
		return # ignore
	
	(body as Player).score_manager.add() # add point
	consumed.emit()
	point_sound_player.play()

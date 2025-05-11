class_name PointManager
extends Node3D

@onready var children := get_children()

func _ready() -> void:
	for element in children:
		element.visible = false
	GameManager.game_start.connect(_on_game_start)

func _on_game_start() -> void:
	start_course()

func start_course() -> void:
	while true:
		for index in range(children.size()):
			var element = (children[index] as MilestonePoint)
			element.visible = true

			await element.consumed
			element.visible = false

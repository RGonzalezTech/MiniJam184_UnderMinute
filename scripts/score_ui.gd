class_name ScoreUI
extends Label

@export var score_manager_path : NodePath = ""
var _score_manager : PlayerScoreManager

func _ready() -> void:
	_score_manager = get_node_or_null(score_manager_path)
	
	assert(_score_manager, "ScoreUI: Missing Score Manager")
	
	_score_manager.score_changed.connect(_on_score_change)
	_update_score(_score_manager.score)

func _on_score_change(new_score: int) -> void:
	_update_score(new_score)

func _update_score(new_score: int) -> void:
	text = ("Score: " + str(new_score))

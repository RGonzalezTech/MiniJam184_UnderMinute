class_name PlayerScoreManager
extends Node

signal score_changed(new_score: int)

@export var score : int = 0

func add() -> void:
	score += 1
	score_changed.emit(score)

class_name GameManagerCode
extends Node

## When the countdown begins
signal countdown_start

## When the game starts
signal game_start

## Game timeout
signal game_end

## Countdown before level starts
@export var countdown : float = 5.0
var countdown_timer : SceneTreeTimer

## Game length before game over
@export var timeout : float = 60.0
var game_timer : SceneTreeTimer

func start_game() -> void:
	countdown_start.emit()
	countdown_timer = get_tree().create_timer(countdown)
	await countdown_timer.timeout
	
	game_start.emit()
	game_timer = get_tree().create_timer(timeout)
	await game_timer.timeout
	
	game_end.emit()
 

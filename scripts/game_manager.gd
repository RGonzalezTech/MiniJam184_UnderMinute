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
var countdown_timer : Timer

## Game length before game over
@export var timeout : float = 60.0
var game_timer : Timer

func reset() -> void:
	if countdown_timer:
		countdown_timer.stop()
		countdown_timer.queue_free()
	
	if game_timer:
		game_timer.stop()
		game_timer.queue_free()

func start_game() -> void:
	reset()

	countdown_timer = Timer.new()
	countdown_timer.wait_time = countdown
	countdown_timer.autostart = true
	countdown_timer.timeout.connect(_on_countdown_finished)
	add_child(countdown_timer)

	countdown_start.emit()
 
func _on_countdown_finished() -> void:
	game_timer = Timer.new()
	game_timer.wait_time = timeout
	game_timer.autostart = true
	game_timer.timeout.connect(_on_game_end)
	add_child(game_timer)
	
	game_start.emit()

func _on_game_end() -> void:
	game_end.emit()

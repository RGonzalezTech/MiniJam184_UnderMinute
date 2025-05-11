class_name PlayerJumpManager
extends Node

signal jumps_changed(new_jumps: int)

## How many jumps you can have at most
const MAX_JUMPS = 3

## How many jumps are available
@export var available_jumps : int = MAX_JUMPS

## How many seconds it takes to get another jump
@export var reload_time : float = 1.0

## Private: time passed
var _elapsed : float = 0.0

## Private: Whether the system is allowing jumps
var jumps_allowed := false

func _ready() -> void:
	GameManager.game_start.connect(_on_game_start)
	GameManager.game_end.connect(_on_game_end)

func _on_game_start() -> void:
	jumps_allowed = true

func _on_game_end() -> void:
	jumps_allowed = false

func _process(delta: float) -> void:
	_handle_reloading(delta)

## Tries to jump and returns a boolean for whether it jumped
func jump() -> bool:
	if not jumps_allowed:
		return false

	if available_jumps > 0:
		available_jumps -= 1
		_emit_jumps()
		return true
	else:
		return false

## Sets jumps back to max
func reset_jumps() -> void:
	available_jumps = MAX_JUMPS
	_emit_jumps()

## Alerts subs of how many jumps we have
func _emit_jumps() -> void:
	jumps_changed.emit(available_jumps)

## Checks if enough time has passed to reload jumps
func _handle_reloading(delta: float) -> void:
	if(available_jumps >= MAX_JUMPS):
		# No reloads necessary
		_elapsed = 0.0
	else:
		_elapsed += delta
		
		# Check if we can add a jump
		if(_elapsed >= reload_time):
			_elapsed -= reload_time # consume the time
			available_jumps += 1 # add another jump
			_emit_jumps() # announce new jumps

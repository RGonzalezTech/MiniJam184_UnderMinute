class_name CountdownUI
extends Label

enum CountdownMode {
	WAIT,
	COUNTDOWN,
	TIMEOUT,
	GAMEOVER,
}

var _current_stage : CountdownMode = CountdownMode.WAIT

func _ready() -> void:
	GameManager.countdown_start.connect(_on_countdown)
	GameManager.game_start.connect(_on_game_start)
	GameManager.game_end.connect(_on_game_end)
	
	await get_tree().create_timer(2.0).timeout
	GameManager.start_game()

func _process(delta: float) -> void:
	match _current_stage:
		CountdownMode.WAIT:
			text = "WAITING"
		CountdownMode.COUNTDOWN:
			text = ("GET READY!\n" + _format_seconds(GameManager.countdown_timer.time_left))
		CountdownMode.TIMEOUT:
			text = ("GO!\n" + _format_seconds(GameManager.game_timer.time_left))
		CountdownMode.GAMEOVER:
			text = "GAME\nOVER"
	
func _on_countdown() -> void:
	_current_stage = CountdownMode.COUNTDOWN

func _on_game_start() -> void:
	_current_stage = CountdownMode.TIMEOUT

func _on_game_end() -> void:
	_current_stage = CountdownMode.GAMEOVER

func _format_seconds(seconds: float) -> String:
	return "%.1f" % seconds

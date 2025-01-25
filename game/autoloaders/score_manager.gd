extends Node

var score: int = 0

func _ready() -> void:
	pass

func increase_score():
	score = score + 1
	SignalManager.update_score.emit(score)

func reset_score():
	score = 0
	SignalManager.update_score.emit(score)

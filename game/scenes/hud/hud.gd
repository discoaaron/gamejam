extends Control

@onready var label: Label = $Label
@onready var game_timer: Label = $GameTimer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.text = str(ScoreManager.score)
	game_timer.text = str(Globals.game_timer)
	SignalManager.update_score.connect(update_score)
	SignalManager.update_timer.connect(update_timer)



func update_score(score: int) -> void:
	label.text = str(score)

func update_timer(timer: int) -> void:
	game_timer.text = str(timer)

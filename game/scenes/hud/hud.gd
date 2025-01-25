extends Control

@onready var label: Label = $Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.text = str(ScoreManager.score)
	SignalManager.update_score.connect(update_score)

func update_score(score: int) -> void:
	label.text = str(score)

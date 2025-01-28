extends Node2D

@onready var timer: Timer = $Timer
var labels: Array[Label]
var visibleLabelIndex = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	labels = [$Text1, $Text2, $Text3, $Text4, $Text5]
	showLabel()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_released("space"):
		timer.stop()
		_on_timer_timeout()

func showLabel() -> void:
	var timerLength;
	if visibleLabelIndex < 2:
		timerLength = 20 
	else:
		timerLength = 5
	labels[visibleLabelIndex].visible = true
	timer.start(timerLength)

func _on_timer_timeout() -> void:
	labels[visibleLabelIndex].visible = false
	visibleLabelIndex = visibleLabelIndex + 1
	if(visibleLabelIndex <= labels.size() - 1):
		showLabel()
	else:
		GameManager.load_menu_scene()

func _on_heartbeat_timeout() -> void:
	$heartbeatsound.play()

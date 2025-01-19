extends Node2D

class_name Baby

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass




func _on_body_area_entered(area: Area2D) -> void:
	SignalManager.baby_enter.emit(area)
	Globals.action_ready = true


func _on_body_area_exited(area: Area2D) -> void:
	SignalManager.baby_exit.emit(area)
	Globals.action_ready = false

extends Node2D


func _on_body_area_entered(area: Area2D) -> void:
	SignalManager.baby_enter.emit(area)
	Globals.action_ready = true


func _on_body_area_exited(area: Area2D) -> void:
	SignalManager.baby_exit.emit(area)
	Globals.action_ready = false

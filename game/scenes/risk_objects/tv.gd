extends StaticBody2D


func _on_action_area_entered(area: Area2D) -> void:
	Globals.tv_action_ready = true
	SignalManager.tv_action_enter.emit()
	print("TV area entered")

func _on_action_area_exited(area: Area2D) -> void:
	Globals.tv_action_ready = false
	SignalManager.tv_action_exit.emit()
	print("TV area exited")

extends StaticBody2D


func _on_action_area_entered(area: Area2D) -> void:
	Globals.lamp_action_ready = true
	SignalManager.lamp_action_enter.emit()
	print("Lamp area entered")


func _on_action_area_exited(area: Area2D) -> void:
	Globals.lamp_action_ready = false
	SignalManager.lamp_action_exit.emit()
	print("Lamp area exited")

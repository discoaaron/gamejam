extends StaticBody2D




func _on_action_area_entered(area: Area2D) -> void:
	Globals.heater_action_ready = true
	SignalManager.heater_action_enter.emit()
	print("Heater area entered")

func _on_action_area_exited(area: Area2D) -> void:
	Globals.heater_action_ready = false
	SignalManager.heater_action_exit.emit()
	print("Heater area exited")

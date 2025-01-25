extends StaticBody2D

class_name Toaster

func _on_action_area_entered(area: Area2D) -> void:
	Globals.toaster_action_ready = true
	SignalManager.toaster_action_enter.emit()
	print("Toaster area entered")

func _on_action_area_exited(area: Area2D) -> void:
	Globals.toaster_action_ready = false
	SignalManager.toaster_action_exit.emit()
	print("Toaster area exited")

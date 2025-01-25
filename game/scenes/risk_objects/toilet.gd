extends StaticBody2D

class_name Toilet


func _on_action_area_entered(area: Area2D) -> void:
	Globals.toilet_action_ready = true
	SignalManager.toilet_action_enter.emit()
	print("Toilet area entered")

func _on_action_area_exited(area: Area2D) -> void:
	Globals.toilet_action_ready = false
	SignalManager.toilet_action_exit.emit()
	print("Toilet area exited")

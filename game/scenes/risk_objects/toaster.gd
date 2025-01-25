extends StaticBody2D

class_name Toaster

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_action_area_entered(area: Area2D) -> void:
	Globals.toaster_action_ready = true
	SignalManager.toaster_action_enter.emit()
	print("Toaster area entered")

func _on_action_area_exited(area: Area2D) -> void:
	Globals.toaster_action_ready = false
	SignalManager.toaster_action_exit.emit()
	print("Toaster area exited")

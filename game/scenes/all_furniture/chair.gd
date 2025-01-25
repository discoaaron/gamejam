extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_chair_area_entered(area: Area2D) -> void:
	SignalManager.chair_enter.emit(area)
	Globals.chair_ready = true
	Globals.target_chair = self
	print("I am chair", Globals.target_chair)

func _on_chair_area_exited(area: Area2D) -> void:
	SignalManager.chair_exit.emit(area)
	Globals.chair_ready = false
	#Globals.target_chair = null #THIS IS CAUSING A BUG!!!! MAY NEED TO REMOVE

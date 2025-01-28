extends StaticBody2D

@onready var chair_sound_one: AudioStreamPlayer2D = $ChairSoundOne
@onready var chair_sound_two: AudioStreamPlayer2D = $ChairSoundTwo


func _on_chair_area_entered(area: Area2D) -> void:
	SignalManager.chair_enter.emit(area)
	Globals.chair_ready = true
	Globals.target_chair = self
	print("I am chair", Globals.target_chair)

func _on_chair_area_exited(area: Area2D) -> void:
	SignalManager.chair_exit.emit(area)
	Globals.chair_ready = false
	#Globals.target_chair = null #THIS IS CAUSING A BUG!!!! MAY NEED TO REMOVE

extends Node

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


func _process(delta: float) -> void:
	if not Globals.menu_intro_sound:
		audio_stream_player.stop()
	if Globals.menu_intro_sound and not audio_stream_player.playing:
		audio_stream_player.play()

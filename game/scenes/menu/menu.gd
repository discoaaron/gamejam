extends Control

func _ready() -> void:
	Globals.menu_intro_sound = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("space"):
		GameManager.load_game_scene()
	

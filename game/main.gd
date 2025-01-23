extends Node2D

var dad_scene = preload("res://scenes/dad/dad.tscn")
var baby_scene = preload("res://scenes/baby/baby.tscn")
var dad: Node
var baby: Node
var screen_size # Size of the game window.
var originalKeys = ["w", "a", "s", "d", "e" ]
var keysCopy = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.baby_lasered.connect(game_over)
	SignalManager.baby_saved.connect(start_next_level)
	screen_size = get_viewport_rect().size
	start_level()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Label.text = str(ScoreManager.score)
	if Input.is_action_just_pressed("space"):
		GameManager.load_menu_scene()
		
func start_level() -> void:
	_spawnDad()
	_spawnBaby()
	
func start_next_level() -> void:
	ScoreManager.increase_score()
	remove_child(dad)
	remove_child(baby)
	start_level()
	print("start new level")
	print(ScoreManager.score)
		
func get_button() -> String:
	if(keysCopy.size() == 0):
		keysCopy = originalKeys.duplicate()
	var keys_index = randi_range(0, keysCopy.size() - 1)
	var key = keysCopy[keys_index]
	keysCopy.remove_at(keys_index)
	return key;
	
func _spawnDad() -> void:
	var keys = originalKeys.duplicate();
	dad = dad_scene.instantiate();
	dad.position = _getRandomPositionOnScreen()
	dad.up = get_button()
	dad.down = get_button()
	dad.left = get_button()
	dad.right = get_button()
	dad.action = get_button()
	add_child(dad)
	
func _spawnBaby() -> void:
	baby = baby_scene.instantiate()
	baby.position = _getRandomPositionOnScreen()
	add_child(baby)
	
func _getRandomPositionOnScreen() -> Vector2:
	return Vector2(randi_range(0, screen_size.x),randi_range(0, screen_size.y))
	
func game_over() -> void:
	ScoreManager.reset_score()
	remove_child(dad)
	remove_child(baby)
	print("ya dun fucked up")

	

	

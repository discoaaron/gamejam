extends Node2D

var dad_scene = preload("res://scenes/dad/dad.tscn")
var baby_scene = preload("res://scenes/baby/baby.tscn")
var dad: Node;
var baby: Node;
var screen_size # Size of the game window.
var keys = ["w", "a", "s", "d", "e" ]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.baby_lasered.connect(laser_baby)
	SignalManager.baby_saved.connect(start_next_level)
	screen_size = get_viewport_rect().size
	start_level()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
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
	var keysCopy = keys.duplicate();
	var key;
	var keys_index = randi_range(0, keysCopy.size() - 1);
	key = keysCopy[keys_index]
	keysCopy.remove_at(keys_index)
	return key;
	
func _spawnDad() -> void:
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
	
func laser_baby() -> void:
	print("ya dun fucked up")

	

	

extends Node2D

var dad_scene = preload("res://scenes/dad/dad.tscn")
var baby_scene = preload("res://scenes/baby/baby.tscn")

var screen_size # Size of the game window.

var keys = ["w", "a", "s", "d", "e" ]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.baby_lasered.connect(laser_baby)
	screen_size = get_viewport_rect().size
	_spawnDad()
	_spawnBaby()
	
func get_button() -> String:
	var key;
	var keys_index = randi_range(0, keys.size() - 1);
	key = keys[keys_index]
	keys.remove_at(keys_index)
	return key;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _spawnDad() -> void:
	var dad = dad_scene.instantiate();
	dad.position = _getRandomPositionOnScreen()
	dad.up = get_button()
	dad.down = get_button()
	dad.left = get_button()
	dad.right = get_button()
	dad.action = get_button()
	add_child(dad)
	
func _spawnBaby() -> void:
	var baby = baby_scene.instantiate()
	baby.position = _getRandomPositionOnScreen()
	add_child(baby)
	
func _getRandomPositionOnScreen() -> Vector2:
	return Vector2(randi_range(0, screen_size.x),randi_range(0, screen_size.y))
	
func laser_baby() -> void:
	print("ya dun fucked up")
	

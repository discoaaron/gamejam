extends Node2D

var dad_scene = preload("res://scenes/dad/dad.tscn")
var baby_scene = preload("res://scenes/baby/baby.tscn")
var dad: Node
var baby: Node
var screen_size # Size of the game window.
var originalKeys = ["w", "a", "s", "d", "e", "q", "z"]
var keysCopy = []
var spawn_offset = 50

@onready var heartbeatsound: AudioStreamPlayer2D = $Heartbeatsound

@onready var heartbeat: Timer = $Heartbeat


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.risk_item_lasered.connect(game_over_laser)
	SignalManager.risk_item_dashed.connect(game_over_dash)
	SignalManager.baby_saved.connect(update_score)
	SignalManager.win_condition_achieved.connect(update_score)
	screen_size = get_viewport_rect().size
	screen_size.x = screen_size.x - spawn_offset
	screen_size.y = screen_size.y - spawn_offset
	start_level()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("space"):
		GameManager.load_menu_scene()
	if Input.is_action_just_pressed("dev_mode"):
		ScoreManager.reset_score()
		dad.up = "w"
		dad.down = "s"
		dad.left = "a"
		dad.right = "d"
		dad.action = "e"
		dad.laser = "q"
		dad.dash = "z"
	heart_pulse()

func start_level() -> void:
	_spawnDad()
	#_spawnBaby()

func update_score() -> void:
	ScoreManager.increase_score()
	start_next_level()

func start_next_level() -> void:
	remove_child(dad)
	remove_child(baby)
	start_level()
	print("start new level")
		
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
	
		# Choose a random location on Path2D.
	var dad_spawn_location = $Dad_Path/DadSpawnLocation
	dad_spawn_location.progress_ratio = randf()
	# Set the mob's position to a random location.
	dad.position = dad_spawn_location.position
	#dad.rotation = Vector2.RIGHT
	#dad.position = _getRandomPositionOnScreen()
	
	dad.up = get_button()
	dad.down = get_button()
	dad.left = get_button()
	dad.right = get_button()
	dad.action = get_button()
	dad.laser = get_button()
	dad.dash = get_button()
	add_child(dad)
	
func _spawnBaby() -> void:
	baby = baby_scene.instantiate()
	baby.position = _getRandomPositionOnScreen()
	add_child(baby)
	
func _getRandomPositionOnScreen() -> Vector2:
	return Vector2(randi_range(spawn_offset, screen_size.x),randi_range(spawn_offset, screen_size.y))
	
func game_over_laser(collidedThing) -> void:
	ScoreManager.reset_score()
	remove_child(dad)
	#remove_child(baby)
	print("ya dun fucked up and lasered: ", collidedThing)

func game_over_dash(collidedThing) -> void:
	if Globals.dashing:
		ScoreManager.reset_score()
		remove_child(dad)
		#remove_child(baby)
		print("ya dun fucked up and dashed into: ", collidedThing)

func heart_pulse() -> void:
	if Globals.heartbeat_pulse_ready:
		heartbeatsound.play()
		heartbeat.start()
		Globals.heartbeat_pulse_ready = false

func _on_heartbeat_timeout() -> void:
	Globals.heartbeat_pulse_ready = true

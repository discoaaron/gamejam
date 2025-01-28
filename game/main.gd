extends Node2D

var dad_scene = preload("res://scenes/dad/dad.tscn")
var baby_scene = preload("res://scenes/baby/baby.tscn")
var heater_scene = preload("res://scenes/risk_objects/heater.tscn")
var lamp_scene = preload("res://scenes/risk_objects/lamp.tscn")
var toaster_scene = preload("res://scenes/risk_objects/toaster.tscn")
var toilet_scene = preload("res://scenes/risk_objects/toilet.tscn")
var tv_scene = preload("res://scenes/risk_objects/tv.tscn")
var risks: Array[Resource] = [heater_scene, lamp_scene, toaster_scene, toilet_scene, tv_scene]

var dad: Node
#var risk: Node
var originalKeys = ["w", "a", "s", "d", "e", "q", "z"]
var keysCopy = []

@onready var heartbeatsound: AudioStreamPlayer2D = $Heartbeatsound

@onready var toaster: StaticBody2D = $RiskItems/Toaster
@onready var toilet: StaticBody2D = $RiskItems/Toilet
@onready var tv: StaticBody2D = $RiskItems/TV
@onready var lamp: StaticBody2D = $RiskItems/Lamp
@onready var heater: StaticBody2D = $RiskItems/Heater
@onready var start_cooldown: Timer = $StartCooldown

@onready var heartbeat: Timer = $Heartbeat


func _ready() -> void:
	SignalManager.risk_item_lasered.connect(game_over_laser)
	SignalManager.risk_item_dashed.connect(game_over_dash)
	SignalManager.baby_saved.connect(update_score)
	SignalManager.win_condition_achieved.connect(update_score)
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
	_spawnBaby()
	Globals.move_cooldown = true
	start_cooldown.start()

func update_score() -> void:
	ScoreManager.increase_score()
	start_next_level()

func start_next_level() -> void:
	remove_child(dad)
	#remove_child(risk)
	dad.queue_free()
	#risk.queue_free()
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
	dad = dad_scene.instantiate();
	var dad_spawn_location = $Dad_Path/DadSpawnLocation
	dad_spawn_location.progress_ratio = randf()
	dad.position = dad_spawn_location.position
	#dad.rotation = todo could set random location
	dad.up = get_button()
	dad.down = get_button()
	dad.left = get_button()
	dad.right = get_button()
	dad.action = get_button()
	dad.laser = get_button()
	dad.dash = get_button()
	set_hud_controls()
	add_child(dad)

func set_hud_controls() -> void:
	$Controls.up_key = str(dad.up).to_upper()
	$Controls.down_key = str(dad.down).to_upper()
	$Controls.left_key = str(dad.left).to_upper()
	$Controls.right_key = str(dad.right).to_upper()
	$Controls.laser_key = str(dad.laser).to_upper()
	$Controls.dash_key = str(dad.dash).to_upper()
	$Controls.action_key = str(dad.action).to_upper()
	
	
func _spawnBaby() -> void:
	var riskIndex = randi_range(0, risks.size() - 1)
	# not sure why this doesn't work
	#var riskScene: Resource = risks[riskIndex]
	#riskScene.instantiate()
	match riskIndex:
		0:
			$Label.text = "Turn off the heater!"
			#risk = heater_scene.instantiate()
			Globals.current_risk = heater
		1:
			$Label.text = "Turn off the lamp!"
			#risk = lamp_scene.instantiate()
			Globals.current_risk = lamp
		2:
			$Label.text = "Toast is burning!"
			#risk = toaster_scene.instantiate()
			Globals.current_risk = toaster
		3:
			$Label.text = "Toilet is overflowing!"
			#risk = toilet_scene.instantiate()
			Globals.current_risk = toilet
		4:
			$Label.text = "TV is melting?!"
			#risk = tv_scene.instantiate()
			Globals.current_risk = tv
	
	#var risk_spawn_location = $Dad_Path/DadSpawnLocation
	#risk_spawn_location.progress_ratio = randf()
	#risk.position = risk_spawn_location.position
	#add_child(risk)

func game_over_laser(collidedThing) -> void:
	var thing_name = str(collidedThing).split(":")[0]
	game_over(str("Game Over\n You lasered the ", thing_name))

func game_over_dash(collidedThing) -> void:
	if Globals.dashing:
		var thing_name = str(collidedThing).split(":")[0]
		game_over(str("Game Over\n You dashed into the ", thing_name))

func game_over(text: String) -> void:
	$Label.text = text
	ScoreManager.reset_score()
	remove_child(dad)
	#remove_child(risk)
	dad.queue_free()
	#risk.queue_free()

func heart_pulse() -> void:
	if Globals.heartbeat_pulse_ready:
		heartbeatsound.play()
		heartbeat.start()
		Globals.heartbeat_pulse_ready = false

func _on_heartbeat_timeout() -> void:
	Globals.heartbeat_pulse_ready = true

func _on_start_cooldown_timeout() -> void:
	Globals.move_cooldown = false

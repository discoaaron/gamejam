extends Node2D

var dad_scene = preload("res://scenes/dad/dad.tscn")
var baby_scene = preload("res://scenes/baby/baby.tscn") #rip

var dad: Node
var originalKeys = ["w", "a", "s", "d", "e", "q", "f"]
var keysCopy = []

var last_10_secs_audio = false
var game_over_flag = false

@onready var heartbeat: Timer = $Heartbeat
@onready var heartbeatsound: AudioStreamPlayer2D = $Heartbeatsound
@onready var confused_audio: AudioStreamPlayer = $ConfusedAudio
@onready var take_a_step_audio: AudioStreamPlayer = $TakeAStepAudio
@onready var success_audio: AudioStreamPlayer = $SuccessAudio
@onready var success_2_audio: AudioStreamPlayer = $Success2Audio
@onready var level_timer: Timer = $Level_Timer
@onready var game_over_audio: AudioStreamPlayer = $GameOver
@onready var whats_cooking_audio: AudioStreamPlayer = $WhatsCookingAudio
@onready var i_smell_saus_audio: AudioStreamPlayer = $ISmellSausAudio

@onready var toaster: StaticBody2D = $RiskItems/Toaster
@onready var toilet: StaticBody2D = $RiskItems/Toilet
@onready var tv: StaticBody2D = $RiskItems/TV
@onready var lamp: StaticBody2D = $RiskItems/Lamp
@onready var heater: StaticBody2D = $RiskItems/Heater
@onready var start_cooldown: Timer = $StartCooldown
@onready var game_over_label: Label = $GameOverLabel

func _ready() -> void:
	SignalManager.risk_item_lasered.connect(game_over_laser)
	SignalManager.risk_item_dashed.connect(game_over_dash)
	SignalManager.baby_saved.connect(update_score)
	SignalManager.win_condition_achieved.connect(update_score)
	#SignalManager.update_timer.connect(update_timer)
	
	# HUD only
	SignalManager.laser_fired.connect(set_hud_controls_laser)
	SignalManager.action_actioned.connect(set_hud_controls_action)
	SignalManager.dash_dashed.connect(set_hud_controls_dash)
	
	ScoreManager.reset_score()
	Globals.menu_intro_sound = false
	start_level()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if game_over_flag && Input.is_action_just_released("space"):
		game_over_flag = false
		ScoreManager.reset_score()
		start_level()
	if Input.is_action_just_pressed("escape") || Input.is_action_just_pressed("enter"):
		GameManager.load_menu_scene()
	if Input.is_action_just_pressed("dev_mode"):
		ScoreManager.reset_score()
		set_default_controls()
		set_all_hud_controls()
	heart_pulse()
	update_timer()

func set_default_controls() -> void:
		dad.up = "w"
		dad.down = "s"
		dad.left = "a"
		dad.right = "d"
		dad.action = "e"
		dad.laser = "q"
		dad.dash = "f"

func start_level() -> void:
	game_over_label.visible = false
	_spawnDad()
	_spawnBaby()
	Globals.move_cooldown = true
	start_cooldown.start()
	set_level_timer()
	level_timer.start()

func update_score() -> void:
	ScoreManager.increase_score()
	start_next_level()

func start_next_level() -> void:	
	remove_child(dad)
	dad.queue_free()
	last_10_secs_audio = false
	# show between level 'thing' here?
	start_level()
		
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
	get_dad_buttons()
	add_child(dad)
	
func get_dad_buttons() -> void:
	match ScoreManager.score:
		0:
			set_default_controls()
			set_all_hud_controls()
			confused_audio.play()
		1: 
			# left and right swapped
			set_default_controls()
			dad.left = "d"
			dad.right = "a"
			set_all_hud_controls()
			success_audio.play()
		2: 
			# left and right AND up and action switched
			set_default_controls()
			dad.left = "d"
			dad.right = "a"
			dad.up = "e"
			dad.action = "w"
			set_all_hud_controls()
			success_2_audio.play()
		_:
			# fully random
			dad.up = get_button()
			dad.down = get_button()
			dad.left = get_button()
			dad.right = get_button()
			dad.action = get_button()
			dad.laser = get_button()
			dad.dash = get_button()
			set_hud_controls_wasd()
			take_a_step_audio.play()
		
func set_all_hud_controls() -> void: 
	set_hud_controls_wasd()
	set_hud_controls_laser()
	set_hud_controls_action()
	set_hud_controls_dash()

func set_hud_controls_wasd() -> void:
	$Controls.up_key = str(dad.up).to_upper()
	$Controls.down_key = str(dad.down).to_upper()
	$Controls.left_key = str(dad.left).to_upper()
	$Controls.right_key = str(dad.right).to_upper()
	$Controls.laser_key = "?"
	$Controls.dash_key = "?"
	$Controls.action_key = "?"

func set_hud_controls_laser() -> void:
	$Controls.laser_key = str(dad.laser).to_upper()
	
func set_hud_controls_action() -> void:
	$Controls.action_key = str(dad.action).to_upper()

func set_hud_controls_dash() -> void:
	$Controls.dash_key = str(dad.dash).to_upper()

func _spawnBaby() -> void:
	var riskIndex = randi_range(0, 4)
	match riskIndex:
		0:
			$Label.text = "Turn off the heater!"
			Globals.current_risk = heater
		1:
			$Label.text = "Turn off the lamp!"
			Globals.current_risk = lamp
		2:
			$Label.text = "Toast is burning!"
			Globals.current_risk = toaster
		3:
			$Label.text = "Toilet is overflowing!"
			Globals.current_risk = toilet
		4:
			$Label.text = "TV is melting?!"
			Globals.current_risk = tv

func game_over_laser(collidedThing) -> void:
	var thing_name = str(collidedThing).split(":")[0]
	game_over(str("Game Over\n You lasered the ", thing_name))

func game_over_dash(collidedThing) -> void:
	if Globals.dashing:
		var thing_name = str(collidedThing).split(":")[0]
		game_over(str("Game Over\n You dashed into the ", thing_name))

func game_over_timer() -> void:
	game_over(str("Game Over\n You ran out of time!"))

func game_over(text: String) -> void:
	game_over_label.visible = true
	game_over_flag = true
	$Label.text = text
	remove_child(dad)
	dad.queue_free()
	level_timer.stop()
	game_over_audio.play()
	Globals.dashing = false

func heart_pulse() -> void:
	if Globals.heartbeat_pulse_ready:
		heartbeatsound.play()
		heartbeat.start()
		Globals.heartbeat_pulse_ready = false

func _on_heartbeat_timeout() -> void:
	Globals.heartbeat_pulse_ready = true

func _on_start_cooldown_timeout() -> void:
	Globals.move_cooldown = false

func set_level_timer() -> void:
	var current_level_time = Globals.game_timer - ScoreManager.score
	if current_level_time >= 15:
		level_timer.wait_time = current_level_time
	else:
		level_timer.wait_time = 15
	print("Level timer is: ", level_timer.wait_time)

func update_timer() -> void:
	if level_timer.time_left > 0:
		var time_left = level_timer.time_left
		SignalManager.update_timer.emit(time_left)
	if level_timer.time_left < 10 and not last_10_secs_audio:
		last_10_secs_audio = true
		var rand_num = randi_range(1,2)
		print("Current risk is: ", Globals.current_risk.name)
		if rand_num == 1 and Globals.current_risk.name != "Toilet":
			whats_cooking_audio.play()
		elif rand_num == 2 and Globals.current_risk.name != "Toilet":
			i_smell_saus_audio.play()

func _on_level_timer_timeout() -> void:
	game_over_timer()

extends CharacterBody2D

@export var speed = 250 # How fast the player will move (pixels/sec).
@export var dash_speed = 800
@export var dash_distance = 100
var dashing = false
var step_audio = false

@export var up = "not_set"
@export var down = "not_set"
@export var left = "not_set"
@export var right = "not_set"
@export var action = "not_set"
@onready var timer: Timer = $Timer
@onready var audio_steps: AudioStreamPlayer2D = $audio_steps
@onready var step_timer: Timer = $audio_steps/Timer
@onready var audio_dash: AudioStreamPlayer2D = $audio_dash

var laser_scene = preload("res://scenes/laser/laser.tscn")
var laser_instance: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	laser_instance = laser_scene.instantiate()
	add_child(laser_instance)
	SignalManager.baby_enter.connect(on_baby_area2d)
	SignalManager.baby_exit.connect(on_baby_exit)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("q"):
		fire_laser(self.position, rotation_degrees)
	if Input.is_action_just_pressed(action):
		if Globals.action_ready:
			SignalManager.baby_saved.emit()
			print("you win!!")
		else:
			print("not quite!")
	if Input.is_action_just_pressed("z"):
		dash_action()

func _physics_process(delta: float) -> void:	
	if not dashing:
		velocity = Vector2.ZERO
		movement_input_check()
		velocity = velocity.normalized() * speed
		move_and_collide(velocity * delta)
	if dashing:
		var direction = rotation
		var vect = Vector2.from_angle(direction)
		var dash_velocity = vect * dash_speed
		move_and_collide(dash_velocity * delta)

func movement_input_check() -> void:
	if Input.is_action_pressed(up):
		velocity.y -= speed
		rotation_degrees = -90
		stepping()
	if Input.is_action_pressed(down):
		velocity.y += speed
		rotation_degrees = 90
		stepping()
	if Input.is_action_pressed(left):
		velocity.x -= speed
		rotation_degrees = -180
		stepping()
	if Input.is_action_pressed(right):
		velocity.x += speed
		rotation_degrees = 0
		stepping()

func on_baby_area2d(area: Area2D) -> void:
	if not dashing:
		print("works", area.name)
	if dashing:
		print("ya messed up")

func on_baby_exit(area: Area2D) -> void:
	print("exit", area.name)

func dash_action() -> void:
	dashing = true
	audio_dash.play()
	timer.start()

func _on_timer_timeout() -> void:
	dashing = false

func fire_laser(start_position: Vector2, rotation: int):
	laser_instance.firing = true
	$LaserTimer.start()
	
func _on_laser_timer_timeout() -> void:
	laser_instance.firing = false

func stepping() -> void:
	if not step_audio:
		step_audio = true
		audio_steps.play()
		step_timer.start()

func _on_step_timer_timeout() -> void:
	step_audio = false

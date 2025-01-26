extends CharacterBody2D

@export var speed = 250 # How fast the player will move (pixels/sec).
@export var dash_speed = 800
@export var dash_distance = 100
var step_audio = false
var sitting = false
var sitting_timer_bool = false
var dad_hands: Area2D = null

@export var up = "not_set"
@export var down = "not_set"
@export var left = "not_set"
@export var right = "not_set"
@export var action = "not_set"
@export var laser = "not_set"
@export var dash = "not_set"
@onready var timer: Timer = $Timer
@onready var audio_steps: AudioStreamPlayer2D = $audio_steps
@onready var step_timer: Timer = $audio_steps/Timer
@onready var audio_dash: AudioStreamPlayer2D = $audio_dash
@onready var sitting_timer: Timer = $SittingTimer

var laser_scene = preload("res://scenes/laser/laser.tscn")
var laser_instance: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	laser_instance = laser_scene.instantiate()
	add_child(laser_instance)
	SignalManager.baby_enter.connect(on_baby_area2d)
	SignalManager.baby_exit.connect(on_baby_exit)
	SignalManager.chair_enter.connect(on_chair_enter_area)
	SignalManager.chair_exit.connect(on_chair_exit_area)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed(laser) and not sitting:
		fire_laser(self.position, rotation_degrees)
	if Input.is_action_just_pressed(action) and not sitting:
		if Globals.action_ready:
			print("you win!!")
			SignalManager.baby_saved.emit()
		elif Globals.chair_ready:
			print("in the chair")
			sit_in_chair(Globals.target_chair)
		elif Globals.toaster_action_ready:
			print("Toaster off")
			SignalManager.win_condition_achieved.emit()
		elif Globals.toilet_action_ready:
			print("Toilet unblocked")
			SignalManager.win_condition_achieved.emit()
		else:
			print("not quite!")
	if Input.is_action_just_pressed(dash) and not sitting:
		dash_action()
	if Input.is_action_just_pressed(action) and sitting and not sitting_timer_bool:
		exit_chair(Globals.target_chair)
	dash_gameover_check(dad_hands)

func _physics_process(delta: float) -> void:	
	if not Globals.dashing:
		velocity = Vector2.ZERO
		movement_input_check()
		velocity = velocity.normalized() * speed
		move_and_collide(velocity * delta)
	if Globals.dashing:
		var direction = rotation
		var vect = Vector2.from_angle(direction)
		var dash_velocity = vect * dash_speed
		move_and_collide(dash_velocity * delta)

func movement_input_check() -> void:
	if Input.is_action_pressed(up) and not sitting:
		velocity.y -= speed
		rotation_degrees = -90
		stepping()
	if Input.is_action_pressed(down) and not sitting:
		velocity.y += speed
		rotation_degrees = 90
		stepping()
	if Input.is_action_pressed(left) and not sitting:
		velocity.x -= speed
		rotation_degrees = -180
		stepping()
	if Input.is_action_pressed(right) and not sitting:
		velocity.x += speed
		rotation_degrees = 0
		stepping()

func on_baby_area2d(area: Area2D) -> void:
	if not Globals.dashing:
		print("works", area.name)
	if Globals.dashing:
		print("ya messed up")

func on_baby_exit(area: Area2D) -> void:
	print("exit", area.name)

func dash_action() -> void:
	Globals.dashing = true
	audio_dash.play()
	timer.start()

func _on_timer_timeout() -> void:
	Globals.dashing = false

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


func sit_in_chair(chair: StaticBody2D) -> void:
	chair.get_node("CollisionShape2D").set_deferred("disabled", true)
	velocity = Vector2.ZERO
	position = Globals.target_chair.global_position
	rotation_degrees = Globals.target_chair.rotation_degrees
	sitting = true
	sitting_timer_bool = true
	sitting_timer.start()
	print("Dad is now sitting in chair at:", position)

func exit_chair(chair: StaticBody2D) -> void:
	chair.get_node("CollisionShape2D").set_deferred("disabled", false)
	sitting = false
	print("Dad is now exiting the chair at:", position)

func _on_sitting_timer_timeout() -> void:
	sitting_timer_bool = false

func on_chair_enter_area(area: Area2D) -> void:
	if not Globals.dashing:
		print("works", area.name)
	if Globals.dashing:
		print("ya messed up the chair")

func on_chair_exit_area(area: Area2D) -> void:
	print("exit", area.name)

func dash_gameover_check(area: Area2D) -> void:
	if area != null:
		var parent = area.get_parent()
		if parent != null and Globals.dashing and parent.is_in_group(Globals.risk_group[0]):
			SignalManager.risk_item_dashed.emit(parent)

func _on_hands_collision_area_entered(area: Area2D) -> void:
	dad_hands = area
	print("dad hands value is: ", dad_hands)

func _on_hands_collision_area_exited(area: Area2D) -> void:
	dad_hands = null
	print("dad hands free")

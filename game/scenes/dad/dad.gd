extends CharacterBody2D


@export var speed = 200 # How fast the player will move (pixels/sec).
@export var dash_speed = 800
@export var dash_distance = 100
@export var dashing = false
@export var up = "not_set"
@export var down = "not_set"
@export var left = "not_set"
@export var right = "not_set"
@export var action = "not_set"

var laser_scene = preload("res://scenes/laser/laser.tscn")
var screen_size # Size of the game window.


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	SignalManager.baby_enter.connect(on_baby_area2d)
	SignalManager.baby_exit.connect(on_baby_exit)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#var velocity = Vector2.ZERO # The player's movement vector.
	#if Input.is_action_pressed(up):
		#velocity.y -= 1
		#rotation_degrees = -90
	#if Input.is_action_pressed(down):
		#velocity.y += 1
		#rotation_degrees = 90
	#if Input.is_action_pressed(left):
		#velocity.x -= 1
		#rotation_degrees = -180
	#if Input.is_action_pressed(right):
		#velocity.x += 1
		#rotation_degrees = 0
	if Input.is_action_pressed("q"):
		fire_laser(self.position, Vector2.RIGHT)
	if Input.is_action_just_pressed(action):
		if Globals.action_ready:
			print("you win!!")
		else:
			print("not quite!")
	if Input.is_action_just_pressed("z"):
		#dashing = true
		dash_action()
	
	#if velocity.length() > 0:
		#velocity = velocity.normalized() * speed
		#$AnimatedSprite2D.play()
	#else:
		#$AnimatedSprite2D.stop()
		
	#position += velocity * delta
	#position = position.clamp(Vector2.ZERO, screen_size)
	


func _physics_process(delta: float) -> void:	
	if not dashing:
		velocity = Vector2.ZERO
		movement_input_check()
		velocity = velocity.normalized() * speed
		move_and_collide(velocity * delta)

func movement_input_check() -> void:
	if Input.is_action_pressed(up):
		velocity.y -= speed
		rotation_degrees = -90
	if Input.is_action_pressed(down):
		velocity.y += speed
		rotation_degrees = 90
	if Input.is_action_pressed(left):
		velocity.x -= speed
		rotation_degrees = -180
	if Input.is_action_pressed(right):
		velocity.x += speed
		rotation_degrees = 0



func fire_laser(start_position: Vector2, direction: Vector2):
	var laser = laser_scene.instantiate()
	add_child(laser)
	laser.global_position = start_position
	laser.laser_direction = direction

func on_baby_area2d(area: Area2D) -> void:
	print("works", area.name)

func on_baby_exit(area: Area2D) -> void:
	print("exit", area.name)


func dash_action() -> void:
	dashing = true
	var direction = rotation
	var vect = Vector2.from_angle(direction)
	var movement = vect * 200 
	position += movement
	dashing = false

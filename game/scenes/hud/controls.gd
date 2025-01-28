extends Node2D

@export var up_key = "W"  
@export var down_key = "S"  
@export var left_key = "A"  
@export var right_key = "D"  
@export var laser_key = "Q"  
@export var dash_key = "F"  
@export var action_key = "E"  

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$UpKey.text = up_key
	$DownKey.text = down_key
	$LeftKey.text = left_key
	$RightKey.text = right_key
	$LaserLabel/LaserKey.text = laser_key
	$DashLabel/DashKey.text = dash_key
	$ActionLabel/ActionKey.text = action_key

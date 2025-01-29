extends RayCast2D

const maxrange = 1000

var based_width = 10
var widthy = based_width
var shoot = false
var active = false
var is_sound_playing = false
@export var laser_direction: Vector2 = Vector2.RIGHT  # Direction the laser fires
@onready var laser_sound: AudioStreamPlayer = $AudioStreamPlayer

@export var firing = false
var laser_offset = 10

func _ready():
	$Line2D.points[0] = position
	$Line2D.points[0].y += laser_offset
	$Line2D.points[0].x += laser_offset
	$Line2D.visible = false
	$Line2D.width = widthy
	target_position = laser_direction.normalized() * maxrange

func _process(delta):
	if firing:
		if not is_sound_playing:
			laser_sound.play()
			is_sound_playing = true
		$Line2D.visible = true
		if is_colliding():
			$Line2D.points[1] = to_local(get_collision_point())
			var collidedThing = get_collider()
			if collidedThing == Globals.current_risk:
				if($Timer.is_stopped()):
					$Timer.start() #gives the player a small chance to save it
		else:
			$Line2D.points[1] = target_position
	else:
		if is_sound_playing:
			laser_sound.stop()
			is_sound_playing = false
		$Line2D.visible = false
		
func _on_timer_timeout() -> void:
	if firing && is_colliding():
		var collidedThing = get_collider()
		if collidedThing == Globals.current_risk:
			SignalManager.risk_item_lasered.emit(collidedThing)

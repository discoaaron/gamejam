extends RayCast2D

const maxrange = 1000

var based_width = 10
var widthy = based_width
var shoot = false
var active = false
var risk_group = ["RiskItems"]
@export var laser_direction: Vector2 = Vector2.RIGHT  # Direction the laser fires
@onready var collision = $Line2D/DamageArea/CollisionShape2D

@export var firing = false

func _ready():
	$Line2D.points[0] = position
	$Line2D.visible = false
	$Line2D.width = widthy
	target_position = laser_direction.normalized() * maxrange

func _process(delta):
	if firing:
		$Line2D.visible = true
		if is_colliding():
			$Line2D.points[1] = to_local(get_collision_point())
			var collidedThing = get_collider()
			for group in risk_group:
				if collidedThing.is_in_group(group):
					SignalManager.risk_item_lasered.emit(collidedThing)
					#print("Collided with: ", collidedThing)
		else:
			$Line2D.points[1] = target_position
	else:
		$Line2D.visible = false

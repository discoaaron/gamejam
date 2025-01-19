extends Node2D

@export var laser_direction: Vector2 = Vector2.RIGHT  # Direction the laser fires
@export var is_active: bool = true                   # Whether the laser is firing

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$RayCast2D/Line2D.add_point(self.position)
	$RayCast2D.target_position = laser_direction.normalized() * 10000  # Large distance for indefinite firing

func _process(delta: float):
	if is_active:
		$RayCast2D.force_raycast_update()
		
		if $RayCast2D.is_colliding():
			# If the laser hits something, limit the visual beam to the collision point
			var collision_point = $RayCast2D.get_collision_point()
			update_laser(collision_point - global_position)
		else:
			# No collision, beam extends indefinitely
			update_laser(laser_direction.normalized() * 10000)

func update_laser(end_position: Vector2):
	$RayCast2D/Line2D.add_point(end_position)
	# Update the Line2D points to reflect the laser path
	#$Line2D. = [Vector2(0, 0), end_position]

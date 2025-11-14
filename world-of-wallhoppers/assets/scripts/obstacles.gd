extends Node2D
class_name Obstacle

@export_enum("Facing Away", "Facing Angle") var launch_mode: int = 0

@export var direction_offset_angle: float = 0.0

func get_direction(to_global_position: Vector2):
	match launch_mode:
		0:
			return global_position.direction_to(to_global_position).rotated(deg_to_rad(direction_offset_angle))
		1:
			return Vector2.from_angle(global_rotation_degrees).rotated(direction_offset_angle)
	return Vector2.ZERO

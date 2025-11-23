extends Node2D
class_name Obstacle

@export var launch_mode: HIT_MODE = HIT_MODE.PUSH_AWAY

enum HIT_MODE {
	PUSH_AWAY,
	PUSH_AT_ANGLE,
	LEFT_OR_RIGHT,
	UP_OR_DOWN,
}

@export var direction_offset_angle: float = 0.0

func get_direction(to_global_position: Vector2):
	match launch_mode:
		HIT_MODE.PUSH_AWAY:
			return global_position.direction_to(to_global_position).rotated(deg_to_rad(direction_offset_angle))
		HIT_MODE.PUSH_AT_ANGLE:
			return Vector2.from_angle(global_rotation_degrees).rotated(direction_offset_angle)
		HIT_MODE.LEFT_OR_RIGHT: 
			return closest(
				global_position.direction_to(to_global_position).rotated(deg_to_rad(direction_offset_angle)), [Vector2.LEFT, Vector2.RIGHT])
		HIT_MODE.UP_OR_DOWN:
			return closest(
				global_position.direction_to(to_global_position).rotated(deg_to_rad(direction_offset_angle)), [Vector2.UP, Vector2.DOWN])
	return Vector2.ZERO

func closest(vector: Vector2, directions: Array[Vector2]) -> Vector2:
	vector = vector.normalized()
	var closest_vector: Vector2 = directions[0]
	var closest_dot: float = vector.dot(directions[0].normalized())
	for index in range(directions.size()):
		var current_vector: Vector2 = directions[index]
		var current_dot: float = vector.dot(current_vector.normalized())
		if current_dot > closest_dot:
			closest_vector = current_vector
			closest_dot = current_dot
	return closest_vector

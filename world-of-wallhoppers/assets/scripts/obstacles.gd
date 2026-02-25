@tool
extends Node2D
class_name Obstacle

var center_offset: Vector2 = Vector2.ZERO

func get_launch_velocity(player: Player) -> Vector2:
	var launch: Vector2 = Vector2.ZERO
	var center: Vector2 = global_position + center_offset
	launch.x = sign(center.direction_to(player.global_position).x) * 320.0
	launch.y = Phys.force_to_launch_to_height(player, 64.0, true)
	return launch

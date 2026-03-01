@tool
extends Area2D
class_name Obstacle

@export var config: CONFIG = CONFIG.NORMAL

var force_multiplier: float = 1.0
var time_multiplier: float = 1.0

enum CONFIG {
	NORMAL,
	LARGE,
	SMALL,
}

func _ready() -> void:
	match config:
		CONFIG.NORMAL:
			force_multiplier = 0.7
			time_multiplier = 0.8
		CONFIG.SMALL:
			force_multiplier = 0.3
			time_multiplier = 0.5

var center_offset: Vector2 = Vector2.ZERO

func get_launch_velocity(player: Player) -> Vector2:
	var launch: Vector2 = Vector2.ZERO
	var center: Vector2 = global_position + center_offset
	launch.x = sign(center.direction_to(player.global_position).x) * 320.0 * force_multiplier
	launch.y = Phys.force_to_launch_to_height(player, 64.0 * force_multiplier, true)
	return launch

func get_time_multiplier() -> float:
	return time_multiplier

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

const NORMAL_FORCE: float = 0.7
const NORMAL_TIME: float = 0.8

const SMALL_FORCE: float = 0.3
const SMALL_TIME: float = 0.5

func _ready() -> void:
	match config:
		CONFIG.NORMAL:
			force_multiplier = NORMAL_FORCE
			time_multiplier = NORMAL_TIME
		CONFIG.SMALL:
			force_multiplier = SMALL_FORCE
			time_multiplier = SMALL_TIME

var center_offset: Vector2 = Vector2.ZERO

func get_launch_velocity(player: Player) -> Vector2:
	var launch: Vector2 = Vector2.ZERO
	var center: Vector2 = global_position + center_offset
	launch.x = sign(center.direction_to(player.global_position).x) * 320.0 * force_multiplier
	launch.y = Phys.force_to_launch_to_height(player, 64.0 * force_multiplier, true)
	return launch

static func get_launch_velocity_from_position(obstacle_global_position: Vector2, player: Player) -> Vector2:
	var launch: Vector2 = Vector2.ZERO
	var center: Vector2 = obstacle_global_position
	launch.x = sign(center.direction_to(player.global_position).x) * 320.0 * NORMAL_FORCE
	launch.y = Phys.force_to_launch_to_height(player, 64.0 * NORMAL_FORCE, true)
	return launch

func get_time_multiplier() -> float:
	return time_multiplier

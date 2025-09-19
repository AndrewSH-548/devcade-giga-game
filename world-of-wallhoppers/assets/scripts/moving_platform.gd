extends Node2D

@onready var animatable_body_2d: AnimatableBody2D = $Path2D/AnimatableBody2D

@onready var path_2d: Path2D = $Path2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var speed_scale: float = 1; ## The speed scaling ratio. For example, if this value is 1, then the platform moves at normal speed. If it's 0.5, then it moves at half speed. If it's 2, then it moves at double speed.

# set the left and right travel points of the platform
@export var left_point_x: int = 0; ## Position is relative to the platform. (ex: 0 pixels horizontally away from the platform)
@export var left_point_y: int = 0; ## Position is relative to the platform. (ex: 0 pixels vertically away from the platform)
@export var right_point_x: int = 240; ## Position is relative to the platform. (ex: 240 pixels horizontally away from the platform)
@export var right_point_y: int = 0; ## Position is relative to the platform. (ex: 0 pixels vertically away from the platform)


func _ready() -> void:
	path_2d.curve.set_point_position(0, Vector2(left_point_x, left_point_y)); # set the position of the path points
	path_2d.curve.set_point_position(1, Vector2(right_point_x, right_point_y));
	
	animation_player.speed_scale = speed_scale; # set the speed_scale of the platform
	animation_player.play("move_platform");

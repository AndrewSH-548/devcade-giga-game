extends Node2D

@onready var animatable_body_2d: AnimatableBody2D = $Path2D/AnimatableBody2D

@onready var target_left: Node2D = $TargetLeft
@onready var target_right: Node2D = $TargetRight
@onready var path_2d: Path2D = $Path2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var platform_movement_time: int = 5; ## the time it takes for the platform to move from one target to another
@export var platform_speed_scale: float = 1; ## The speed scaling ratio. For example, if this value is 1, then the platform moves at normal speed. If it's 0.5, then it moves at half speed. If it's 2, then it moves at double speed.

# set the left and right travel points of the platform
@export var target_left_position_x: int = -120; ## Position is relative to the platform. (ex: 120 pixels horizontally away from the platform)
@export var target_left_position_y: int = 0; ## Position is relative to the platform. (ex: 0 pixels vertically away from the platform)
@export var target_right_position_x: int = 120; ## Position is relative to the platform. (ex: 120 pixels horizontally away from the platform)
@export var target_right_position_y: int = 0; ## Position is relative to the platform. (ex: 0 pixels vertically away from the platform)

const SPEED = 200

var go_left = true; # determines to go left or right
var go_right = false;

var tween; 

func _ready() -> void:
	target_left.position = Vector2(target_left_position_x, target_left_position_y); # set the target's position
	target_right.position = Vector2(target_right_position_x, target_right_position_y);
	path_2d.curve.set_point_position(0, Vector2(target_left_position_x, target_left_position_y));
	path_2d.curve.set_point_position(1, Vector2(target_right_position_x, target_right_position_y));
	
	animation_player.speed_scale = platform_speed_scale;
	animation_player.play("move_platform");
	
func _process(delta: float) -> void:
	tween = get_tree().create_tween();
	var distance;
	var tween_time;
	#if go_left: # go to the left target's position
	#	distance = position.distance_to(target_left.position); # for platform movement
	#	tween_time = distance / SPEED;
	#	tween.tween_property(animatable_body_2d, "position", target_left.position, tween_time).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT_IN);
	#elif go_right: # go to the right target's position
	#	distance = position.distance_to(target_right.position); # for platform movement
	#	tween_time = distance / SPEED;
	#	tween.tween_property(animatable_body_2d, "position", target_right.position, tween_time).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT_IN);

	if animatable_body_2d.position <= (target_left.position + Vector2(5, 0)): # change to going right
		go_left = false;
		go_right = true;
	elif animatable_body_2d.position >= (target_right.position + Vector2(-5, 0)): # change to going left
		go_left = true;
		go_right = false;

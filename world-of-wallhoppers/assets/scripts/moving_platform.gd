extends Node2D

## The platform will pause at PauseArea(s) (although there is a cooldown timer of 0.5s). 
## You can manually add points by going to Path2D > Curve > Points (Add Element).

@onready var platform_body: AnimatableBody2D = $Path2D/PlatformBody
@onready var pause_area: Node2D = $PauseArea

@onready var path_2d: Path2D = $Path2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var remote_transform_2d: RemoteTransform2D = $Path2D/PathFollow2D/RemoteTransform2D

@onready var pause_timer: Timer = $PauseTimer
@onready var pause_cooldown_timer: Timer = $PauseCooldownTimer

# set the left and right travel points of the platform
@export var left_point_x: int = 0; ## Position is relative to the platform. (ex: 0 pixels horizontally away from the platform)
@export var left_point_y: int = 0; ## Position is relative to the platform. (ex: 0 pixels vertically away from the platform)
@export var right_point_x: int = 240; ## Position is relative to the platform. (ex: 240 pixels horizontally away from the platform)
@export var right_point_y: int = 0; ## Position is relative to the platform. (ex: 0 pixels vertically away from the platform)

@export var speed_scale: float = 1; ## The speed scaling ratio. For example, if this value is 1, then the platform moves at normal speed. If it's 0.5, then it moves at half speed. If it's 2, then it moves at double speed.

const PLATFORM_PAUSE_DELAY = 1;

var paused = false;

func _ready() -> void:
	path_2d.curve.set_point_position(0, Vector2(left_point_x, left_point_y)); # set the position of the path points
	path_2d.curve.set_point_position(1, Vector2(right_point_x, right_point_y));
	
	animation_player.speed_scale = speed_scale; # set the speed_scale of the platform
	animation_player.play("move_platform");

func _process(delta: float) -> void:
	if !paused && pause_cooldown_timer.is_stopped(): # pauses the platform at the pause_area for PLATFORM_PAUSE_DELAY seconds
		if (platform_body.global_position >= pause_area.global_position - Vector2(5, 5)) && (platform_body.global_position <= pause_area.global_position + Vector2(5, 5)):
			#print("PAUSE")
			remote_transform_2d.update_position = false;
			paused = true;
			animation_player.pause() # pause the movement animation
			pause_timer.start(PLATFORM_PAUSE_DELAY);

#func add_point() -> void:
	#path_2d.curve.add_point()


func _on_pause_timer_timeout() -> void: # unpauses the platform
	remote_transform_2d.update_position = true;
	paused = false;
	animation_player.play(); # continue the movement animation
	pause_cooldown_timer.start() # starts a cooldown before the platform can be paused again

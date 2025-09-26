extends Node2D

## The platform will pause at PauseArea(s) (although there is a cooldown timer of 0.5s). 
## You can manually add points by going to Path2D > Curve > Points (Add Element).
## This does cause lots of Zero Length Interval Errors. It doesn't crash the game though.

@onready var platform_body: AnimatableBody2D = $Path2D/PlatformBody

@onready var default_start_point: Node2D = $DefaultPathPoints/DefaultStartPoint
@onready var default_end_point: Node2D = $DefaultPathPoints/DefaultEndPoint
@onready var pause_area: Node2D = $PauseArea

@onready var path_2d: Path2D = $Path2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var remote_transform_2d: RemoteTransform2D = $Path2D/PathFollow2D/RemoteTransform2D

@onready var pause_timer: Timer = $PauseTimer
@onready var pause_cooldown_timer: Timer = $PauseCooldownTimer

# Points
@export var start_point_0: Node2D; ## Create a Node(can be anything with a position) and set this variable to it. That node will be the platform's start.
@export var end_point_7: Node2D = default_end_point; ## Create a Node(can be anything with a position) and set this variable to it. That node will be the platform's end.
@export var point_1: Node2D = default_start_point; ## Create a Node(can be anything with a position) and set this variable to it. That node will be the 1st point on the platform's path.
@export var point_2: Node2D = default_start_point; ## Create a Node(can be anything with a position) and set this variable to it. That node will be the 2nd point on the platform's path.
@export var point_3: Node2D = default_start_point; ## Create a Node(can be anything with a position) and set this variable to it. That node will be the 3rd point on the platform's path.
@export var point_4: Node2D = default_start_point; ## Create a Node(can be anything with a position) and set this variable to it. That node will be the 4th point on the platform's path.
@export var point_5: Node2D = default_start_point; ## Create a Node(can be anything with a position) and set this variable to it. That node will be the 5th point on the platform's path.
@export var point_6: Node2D = default_start_point; ## Create a Node(can be anything with a position) and set this variable to it. That node will be the 6th point on the platform's path.
var number_of_points = 8;

# set the left and right travel points of the platform
@export var start_point_x: float = 0.0; ## Position is relative to the platform. (ex: 0 pixels horizontally away from the platform)
@export var start_point_y: float = 0.0; ## Position is relative to the platform. (ex: 0 pixels vertically away from the platform)
@export var end_point_x: float = 240.0; ## Position is relative to the platform. (ex: 240 pixels horizontally away from the platform)
@export var end_point_y: float = 0.0; ## Position is relative to the platform. (ex: 0 pixels vertically away from the platform)

@export var speed_scale: float = 1; ## The speed scaling ratio. For example, if this value is 1, then the platform moves at normal speed. If it's 0.5, then it moves at half speed. If it's 2, then it moves at double speed.

const PLATFORM_PAUSE_DELAY = 1;

var paused = false;

func _ready() -> void:
	if start_point_0 != null: # if the start and end points have been changed, update their positions
		start_point_x = start_point_0.global_position.x - self.global_position.x;
		start_point_y = start_point_0.global_position.y - self.global_position.y;
	else: # otherwise, set the start point to the default
		start_point_0 = default_start_point;
		start_point_x = start_point_0.global_position.x - self.global_position.x;
		start_point_y = start_point_0.global_position.y - self.global_position.y;
	if end_point_7 != null:
		end_point_x = end_point_7.global_position.x - self.global_position.x;
		end_point_y = end_point_7.global_position.y - self.global_position.y;
	else:
		end_point_7 = default_end_point;
		end_point_x = end_point_7.global_position.x;
		end_point_y = end_point_7.global_position.y;
	
	if point_1 == null: # if the points are not set, then default them to the end point (it does not work if you set them directly in the export variables)
		point_1 = end_point_7;
	if point_2 == null:
		point_2 = end_point_7;
	if point_3 == null:
		point_3 = end_point_7;
	if point_4 == null:
		point_4 = end_point_7;
	if point_5 == null:
		point_5 = end_point_7;
	if point_6 == null:
		point_6 = end_point_7;

	path_2d.curve.set_point_position(0, Vector2(start_point_x, start_point_y)); # set the position of the path points
	path_2d.curve.set_point_position(7, Vector2(end_point_x, end_point_y));
	# subtract self.global_position to actually set the points right.
	path_2d.curve.set_point_position(1, Vector2(point_1.global_position.x - self.global_position.x, point_1.global_position.y - self.global_position.y)); # set the position of the path points
	path_2d.curve.set_point_position(2, Vector2(point_2.global_position.x - self.global_position.x, point_2.global_position.y - self.global_position.y)); # set the position of the path points
	path_2d.curve.set_point_position(3, Vector2(point_3.global_position.x - self.global_position.x, point_3.global_position.y - self.global_position.y)); # set the position of the path points
	path_2d.curve.set_point_position(4, Vector2(point_4.global_position.x - self.global_position.x, point_4.global_position.y - self.global_position.y)); # set the position of the path points
	path_2d.curve.set_point_position(5, Vector2(point_5.global_position.x - self.global_position.x, point_5.global_position.y - self.global_position.y)); # set the position of the path points
	path_2d.curve.set_point_position(6, Vector2(point_6.global_position.x - self.global_position.x, point_6.global_position.y - self.global_position.y)); # set the position of the path points
	
	animation_player.speed_scale = speed_scale; # set the speed_scale of the platform
	animation_player.play("move_platform");

func _process(delta: float) -> void:
	if !paused && pause_cooldown_timer.is_stopped(): # pauses the platform at the pause_area for PLATFORM_PAUSE_DELAY seconds
		if (platform_body.global_position >= pause_area.global_position - Vector2(0.5, 0.5)) && (platform_body.global_position <= pause_area.global_position + Vector2(0.5, 0.5)):
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

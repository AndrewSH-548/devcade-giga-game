extends Node2D

## The platform will pause at PauseArea(s)
## You can manually add (up to 8) points and pause areas by going to Path2D > Curve > Points (Add Element).
## This causes lots of [Zero Length Interval Errors], but the game will still run.

@onready var platform_body: AnimatableBody2D = $Path2D/PlatformBody

@onready var default_start_point: Node2D = $DefaultPathPoints/DefaultStartPoint
@onready var default_end_point: Node2D = $DefaultPathPoints/DefaultEndPoint
@onready var default_pause_area: Node2D = $DefaultPauseArea

@onready var path_2d: Path2D = $Path2D
@onready var path_follow_2d: PathFollow2D = $Path2D/PathFollow2D
@onready var remote_transform_2d: RemoteTransform2D = $Path2D/PathFollow2D/RemoteTransform2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var pause_timer: Timer = $PauseTimer
@onready var pause_cooldown_timer: Timer = $PauseCooldownTimer

# Points
@export var start_point_0: Node2D; ## Create a Node(can be anything with a position) and set this variable to it. That node will be the platform's start. The default position is the platform's (0, 0).
@export var end_point: Node2D; ## Create a Node(can be anything with a position) and set this variable to it. That node will be the platform's end. The default position is the platform's (0, 0).
@export var points: Array[Node2D]; ## Create a Node(can be anything with a position) and set it to a value in this array. That node will be the (_) point on the platform's path. The platform travels in order, starting from Start_Point and ending at End_Point.

# Pauses
@export var pauses: Array[Node2D]; ## Create a Node(can be anything with a position) and set it to a value in this array. The platform will pause at that location for (pause_duration) seconds.
@export var pause_area_radius: float = 8; ## The minimum distance from the pause area that will cause the platform to pause.
@export var pause_duration: float = 0.8; ## The time(in seconds) the platform will stay paused.

@export var speed_scale: float = 0.6; ## The speed scaling ratio. For example, if this value is 1, then the platform moves at normal speed. If it's 0.5, then it moves at half speed. If it's 2, then it moves at double speed.
@export var path_type: String = "BOUNCE"; ## The type of path the platform will follow. [BOUNCE] or [LOOP]. For [BOUNCE] the platform will travel start>end, end> start. For [LOOP] the platform will travel start>end, start>end continuously.

var paused = false; ## If the platform is paused. Then this is true
var pause_enabled = true; ## Stores if the pause_areas are enabled or not.
	
enum Path_System { ## different states for the path behavior
	BOUNCE, ## travel from start->end, then end->start
	LOOP, ## travel in a loop: start->end, start->end
};

var current_state = Path_System.BOUNCE; ## The current state of the Path_System. The default is BOUNCE.

func _ready() -> void:
	for i in path_2d.curve.point_count: # remove all points except for the start and end ones (cleans up the path before implementing stuff)
		if (i != 0) && (i+1 != path_2d.curve.point_count):
			path_2d.curve.remove_point(i)

	if start_point_0 == null: # if the points are not set, then default them to the defaults (it does not work if you set them directly in the export variables)
		start_point_0 = default_start_point;
	if end_point == null:
		end_point = default_end_point;

	if (pauses == null): # if the pauses array is empty, then disable pause
		pause_enabled = false;

	# set the position of the path points (subtract self.global_position to set the points at the right position)
	path_2d.curve.set_point_position(0, Vector2(start_point_0.global_position.x - self.global_position.x, start_point_0.global_position.y - self.global_position.y));
	path_2d.curve.set_point_position(1, Vector2(end_point.global_position.x - self.global_position.x, end_point.global_position.y - self.global_position.y));

	for i in range(len(points)): # sets the points to their assigned positions
		path_2d.curve.add_point(Vector2(points[i].global_position.x - self.global_position.x, points[i].global_position.y - self.global_position.y), Vector2(0, 0), Vector2(0, 0), i+1);


	match path_type.to_upper(): # set the path type based on the variable
		"LOOP":
			current_state = Path_System.LOOP;
		"BOUNCE":
			current_state = Path_System.BOUNCE;
		_:
			print_debug("ERROR: Please Input LOOP or BOUNCE for the path type.");
	
	if current_state == Path_System.BOUNCE: # run BOUNCE path system
		animation_player.speed_scale = speed_scale; # set the speed_scale of the platform for (BOUNCE)
		animation_player.play("move_platform");
	elif current_state == Path_System.LOOP:
		pass


func _process(delta: float) -> void:
	if !paused && (current_state == Path_System.LOOP): # run LOOP path system
		path_follow_2d.progress += (10 * speed_scale); # continuously increase the platform's path progression (LOOPs)

	if !paused && pause_cooldown_timer.is_stopped(): # pause system. pauses the platform at the pause_area for PLATFORM_PAUSE_DELAY seconds
		if is_touching_pause_area():
			remote_transform_2d.update_position = false;
			paused = true;
			animation_player.pause(); # pause the movement animation
			pause_timer.start(pause_duration);
		

func is_touching_pause_area() -> bool: ## check for contact with pause_areas
	if pause_enabled == false:
		return false;
	
	for i in len(pauses):
		if platform_body.global_position.distance_to(pauses[i].global_position) < pause_area_radius:
			return true;
	
	return false;
	

func _on_pause_timer_timeout() -> void: ## unpauses the platform
	remote_transform_2d.update_position = true;
	paused = false;
	if current_state == Path_System.BOUNCE:
		animation_player.play(); # continue the movement animation
	pause_cooldown_timer.start(); # starts a cooldown before the platform can be paused again

func change_state(next_state) -> void: ## changes the Path_System's state
	current_state = next_state;
	

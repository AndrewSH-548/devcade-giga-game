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

@onready var main_sprite: Sprite2D = $Path2D/PlatformBody/MainSprite
@onready var wheel_sprite: Sprite2D = $Path2D/PlatformBody/WheelSprite

# Points
@export var start_point_0: Node2D; ## Create a Node(can be anything with a position) and set this variable to it. That node will be the platform's start. The default position is the platform's (0, 0).
@export var end_point: Node2D; ## Create a Node(can be anything with a position) and set this variable to it. That node will be the platform's end. The default position is the platform's (0, 0).
@export var points: Array[Node2D]; ## Create a Node(can be anything with a position) and set it to a value in this array. That node will be the (_) point on the platform's path. The platform travels in order, starting from Start_Point and ending at End_Point.

# Pauses
@export var pauses: Array[Node2D]; ## Create a Node(can be anything with a position) and set it to a value in this array. The platform will pause at that location for (pause_duration) seconds.
@export var pause_area_radius: float = 8; ## The minimum distance from the pause area that will cause the platform to pause.
@export var pause_duration: float = 0.8; ## The time(in seconds) the platform will stay paused.

@export var speed_scale: float = 1.0; ## The speed scaling ratio. For example, if this value is 1, then the platform moves at normal speed. If it's 0.5, then it moves at half speed. If it's 2, then it moves at double speed.
@export var path_type: Path_System = Path_System.BOUNCE; ## The type of path the platform will follow. [BOUNCE] or [LOOP]. For [BOUNCE] the platform will travel start>end, end> start. For [LOOP] the platform will travel start>end, start>end continuously.
@export var decoration_type: DecoType

const MOVING_PLATFORM_PATH = preload("uid://k6238xtiriwm") ## Scene which contains the visuals for a single path part. These are constructed using the moving platform's path points
const MOVING_PLATFORM_REST = preload("uid://yx5v3vnlt8nw") ## Scene which contains the visuals for a rest point

const SPRITE_VOLCANO_ROCKS = preload("uid://cbxgmsa0gp044")
const SPRITE_JUNGLE_WOOD = preload("uid://baeulnudn7mq7")

var paused = false; ## If the platform is paused. Then this is true
var pause_enabled = true; ## Stores if the pause_areas are enabled or not.
var speed_factor: float = 1.0 ## Used internally. This is the inverse of the length of the platform's path. Used to keep the platform's speed consistent with different length paths

enum Path_System { ## different states for the path behavior
	BOUNCE, ## travel from start->end, then end->start
	LOOP, ## travel in a loop: start->end, start->end
};

enum DecoType {
	LAVA_ROCKS,
	JUNGLE_WOOD,
}

var current_state = Path_System.BOUNCE; ## The current state of the Path_System. The default is BOUNCE.

# ---------- TO ADD A NEW PLATFORM VARIATION ----------
#
# 1: Add the name to the "DecoType" enum
# 3: Go to eaach of the "Color" sections (Near the bottom of ready), and setup the wheel and track colors

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

	# set the position of the path points (use to_local on the nodes's globals positions for correct points)
	path_2d.curve.set_point_position(0, to_local(start_point_0.global_position));
	path_2d.curve.set_point_position(1, to_local(end_point.global_position));

	for i in range(len(points)): # sets the points to their assigned positions
		path_2d.curve.add_point(to_local(points[i].global_position), Vector2(0, 0), Vector2(0, 0), i+1);
	
	current_state = path_type
	
	# Scale the speed of the platform based on path length
	# This makes the platform's speed always consistent
	speed_factor = 1.0 / path_2d.curve.get_baked_length()
	
	if current_state == Path_System.BOUNCE: # run BOUNCE path system
		animation_player.speed_scale = speed_scale * speed_factor * 128.0; # set the speed_scale of the platform for (BOUNCE)
		animation_player.play("move_platform");
	elif current_state == Path_System.LOOP:
		pass
	
	# Next the visual tracks and rests will be placed
	# Wait one frame, because we need to let the parent node setup it's children
	await get_tree().process_frame
	
	# Get the (very large) array of points in the curve
	# Note that this is NOT the points we chose, instead it's hundreds of points which form the curve
	# that is CREATED by the points we chose
	var points: PackedVector2Array = path_2d.curve.get_baked_points()
	# Will store the last position a track was placed
	var last_position: Vector2
	# Will store the last track node what was placed
	var last_track: NinePatchRect = null
	# For each point
	for index in range(points.size()):
		# If it's the last point...
		if index >= points.size() - 1:
			# Looping
			if current_state == Path_System.LOOP:
				index = 0
				# Currently looping is teleporting, but if it ever becmes a smooth loop, just delete this BREAK statement below:
				break
			# Bouncing
			else:
				# End the loop
				break
		# Get current point and next point, and add randomness to current for visual flair
		var point: Vector2 = points[index] + Vector2(randi_range(-2, 2), randi_range(-2, 2)) - Vector2(0, 4)
		var next_point: Vector2 = points[index + 1]
		# Only place tracks a certain distance aprart
		# This stops hundreds of tracks being placed
		if index == 0 or last_position.distance_to(point) > 32:
			# If there was a last track, adjust it to connect to this track
			if last_track != null:
				last_track.size.x = last_position.distance_to(point)
				last_track.rotation = last_position.angle_to_point(point)
			# Save the current position
			last_position = point
			# Create the new track
			var path_visual: NinePatchRect = MOVING_PLATFORM_PATH.instantiate()
			get_parent().add_child(path_visual)
			
			# COLOR SECTION TRACK --------------------------
			match decoration_type:
				DecoType.LAVA_ROCKS:
					path_visual.modulate = Color(0.396, 0.12, 0.09, 1.0)
				DecoType.JUNGLE_WOOD:
					path_visual.modulate = Color(0.531, 0.281, 0.123, 1.0)
			# ----------------------------------------------
			
			# Position the new track and save it for the next track
			path_visual.global_position = global_position + point
			path_visual.size.x = 0
			last_track = path_visual
	
	# Sets up the visuals for pauses
	for pause in pauses:
		var position: Vector2 = pause.global_position + Vector2(-6, 6)
		var rest: Node2D = MOVING_PLATFORM_REST.instantiate()
		get_parent().add_child(rest)
		rest.global_position = position
	
	# COLOR SECTION WHEEL --------------------------
	# Sets up the main platform's sprite
	match decoration_type:
		DecoType.LAVA_ROCKS:
			main_sprite.texture = SPRITE_VOLCANO_ROCKS
			wheel_sprite.modulate = Color(0.608, 0.224, 0.15, 1.0)
		DecoType.JUNGLE_WOOD:
			main_sprite.texture = SPRITE_JUNGLE_WOOD
			wheel_sprite.modulate = Color(0.59, 0.333, 0.205, 1.0)
	# ----------------------------------------------


func _process(delta: float) -> void:
	if !paused && (current_state == Path_System.LOOP): # run LOOP path system
		path_follow_2d.progress += (128 * 60 * 10 * speed_scale * speed_factor * delta); # continuously increase the platform's path progression (LOOPs)

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
	

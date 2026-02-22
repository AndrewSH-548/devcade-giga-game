extends Player
class_name PlayerScoria

@onready var normal_collision: CollisionShape2D = $NormalCollision
@onready var roll_collision: CollisionShape2D = $RollCollision

@onready var dash_timer: Timer = $Timers/Dash
@onready var rebound_timer: Timer = $Timers/Rebound
@onready var flight_timer: Timer = $Timers/Flight
@onready var re_dash_timer: Timer = $Timers/ReDash

@onready var dash_buffer_timer: Timer = $Timers/DashBuffer

@onready var animations: AnimatedSprite2D = $Animations
@onready var spark_animation: AnimatedSprite2D = $Spark

@onready var foot_position_marker: Marker2D = $FootPositionMarker

const SPRITE_SCORIA = preload("uid://bsvpbsp4u6vv0")
const SPRITE_SIZE: Vector2i = Vector2i(84, 84)

var sprite_frames: Array[SpriteFrames]

var dash_action: StringName
var roll_action: StringName

var dash_speed: float = 512.0
var dash_time: float = 0.13
var dash_buffer_time: float = 0.2
var can_dash: bool = true
var re_dash_time: float = 0.5

var rebound_direction: int = 1
var rebound_time: float = 0.3
var rebound_pushoff_strength: float = 120.0
var rebound_boost_strength: float = 400.0
var rebound_leeway: float = 16.0

var spark_progress: float = 0.0
var rebound_spark_amount: float = 1.3
var spark_drain_per_second: float = 0.0

var flight_speed: float = 800.0
var flight_time: float = 0.5
var flight_offset_x: float = 32.0
var flight_target_x: float
var flight_gravity: float = 1000.0

var roll_speed: float = 320.0
var roll_gravity: float = 1280.0
var roll_bounce_strength: float = 300.0
var roll_launch_strength: float = 0.0

var slam_speed: float = 1024.0

var on_floor_last_frame: bool = false

var move_state: MoveState = MoveState.NORMAL

enum MoveState {
	NORMAL,
	ROLL,
	DASH,
	REBOUND,
	SLAM,
	FLIGHT,
}

func _ready() -> void:
	foot_offset = foot_position_marker.global_position - global_position
	for index in range(5):
		sprite_frames.append(make_frames(index))
	animations.sprite_frames = sprite_frames[0]
	super._ready()

func make_frames(index: int) -> SpriteFrames:
	var frames: SpriteFrames = SpriteFrames.new()
	make_animation(frames, "Idle", index, [0])
	make_animation(frames, "Walk", index, [1, 2, 3, 4], 8.0)
	make_animation(frames, "Roll", index, [5, 6, 7], (12.0 if index != 4 else 8.0))
	make_animation(frames, "Hitstun", index, [8])
	make_animation(frames, "Against Wall", index, [9])
	make_animation(frames, "Jump", index, [10])
	make_animation(frames, "Fall", index, [11])
	make_animation(frames, "On Wall", index, [12])
	return frames

func make_animation(frames: SpriteFrames, animation_name: StringName, row_index: int, column_indicies: Array[int], fps: float = 0.0, loop: bool = true) -> void:
	frames.add_animation(animation_name)
	frames.set_animation_speed(animation_name, fps)
	frames.set_animation_loop(animation_name, loop)
	for column_index in range(column_indicies.size()):
		frames.add_frame(animation_name, make_atlas(Vector2i(column_indicies[column_index], row_index)))

func make_atlas(coords: Vector2i) -> AtlasTexture:
	var atlas: AtlasTexture = AtlasTexture.new()
	atlas.atlas = SPRITE_SCORIA
	atlas.region.size = SPRITE_SIZE
	atlas.region.position = Vector2(SPRITE_SIZE * coords)
	return atlas

func _physics_process(delta: float) -> void:
	var header = get_tree().get_first_node_in_group("LevelHeader")
	if header != null and header.paused:
		return
	if halt_physics:
		return
	
	var modified_delta: float = get_modified_delta(delta)
	
	var direction: float = get_horizontal_movement()
	
	spark_progress = move_toward(spark_progress, 0.0, spark_drain_per_second * modified_delta)
	
	if move_state != MoveState.NORMAL:
		if Input.is_action_just_pressed(dash_action):
			dash_buffer_timer.start(dash_buffer_time)
	
	roll_collision.disabled = move_state != MoveState.ROLL
	normal_collision.disabled = move_state == MoveState.ROLL
	
	
	if get_position_state() != STATE_HITSTUN:
		match move_state:
			MoveState.NORMAL:
				process_walkrun(modified_delta, direction)
				process_gravity(modified_delta)
				process_jump(modified_delta)
				process_wallcheck(modified_delta)
				process_walljump(modified_delta)
				if Input.is_action_just_pressed(roll_action):
					do_roll()
			# SCRAPPED DASH, WAS REPLACED BY ROLL
			#MoveState.DASH:
			#	process_dash()
			MoveState.REBOUND:
				process_rebound()
				process_gravity(modified_delta)
			MoveState.SLAM:
				process_slam(modified_delta)
			MoveState.FLIGHT:
				process_flight(modified_delta)
			MoveState.ROLL:
				process_roll(modified_delta)
				if Input.is_action_just_pressed(down_action):
					move_state = MoveState.SLAM
	else:
		process_gravity(modified_delta)
		move_state = MoveState.NORMAL
	
	if move_state != MoveState.ROLL:
		update_flipped()
	animated_scoria()
	
	on_floor_last_frame = is_on_floor()
	move(delta, modified_delta)

func do_dash():
	move_state = MoveState.DASH
	dash_timer.start(dash_time)
	can_dash = false
	re_dash_timer.start(re_dash_time)

func do_rebound(wall_direction: int):
	can_dash = true
	move_state = MoveState.REBOUND
	dash_timer.stop()
	do_spark()
	if spark_progress >= 3.0:
		do_flight(wall_direction)
	else:
		rebound_direction = -wall_direction
		velocity.x = rebound_pushoff_strength * wall_direction
		velocity.y = -rebound_boost_strength
		rebound_timer.start(rebound_time)

func do_flight(away_direction: int):
	flight_target_x = global_position.x + flight_offset_x * away_direction
	velocity.y = -flight_speed
	move_state = MoveState.FLIGHT
	flight_timer.start(flight_time)

func do_roll():
	move_state = MoveState.ROLL
	velocity.y = -roll_launch_strength

func do_spark():
	spark_progress += rebound_spark_amount
	spark_animation.play()

func process_dash():
	velocity.y = 0
	velocity.x = dash_speed * facing
	
	if test_wall_direction(facing * rebound_leeway):
		snap_wall_direction(facing * rebound_leeway)
		do_rebound(-facing)

func process_rebound():
	pass

func process_flight(delta: float):
	var target_position: float =  lerp(global_position.x, flight_target_x, (0.2**(delta * 60.0)))
	velocity.x = (target_position - global_position.x) / delta
	
	velocity.y += flight_gravity * delta
	
	if is_on_ceiling():
		flight_timer.stop()
		flight_timer_end()

func process_roll(delta: float):
	velocity.x = facing * roll_speed
	velocity.y += roll_gravity * delta
	
	if is_on_floor():
		update_flipped()
		velocity.y = -roll_bounce_strength
	
	if is_on_floor() and not on_floor_last_frame:
		do_spark()
	
	if test_wall_direction(facing * rebound_leeway):
		snap_wall_direction(facing * rebound_leeway)
		do_rebound(-facing)

func process_slam(_delta: float):
	velocity.y = slam_speed
	velocity.x = 0.0
	if is_on_floor():
		do_roll()

func animated_scoria():
	sprite.flip_h = !is_facing_right
	
	if move_state == MoveState.SLAM:
		animations.scale.x = 0.7
		animations.scale.y = 1.2
	else:
		animations.scale = Vector2.ONE
	
	if get_position_state() == STATE_HITSTUN:
		animations.animation = "Hitstun"
	else:
		match move_state:
			MoveState.FLIGHT, MoveState.ROLL:
				animations.animation = "Roll"
			MoveState.NORMAL:
				if is_on_floor():
					if ((is_touching_right_wall() and is_facing_right) or (is_touching_left_wall() and not is_facing_right)) and get_horizontal_movement() != 0.0:
						animations.animation = "Against Wall"
					elif get_horizontal_movement() == 0.0:
						animations.animation = "Idle"
					else:
						animations.animation = "Walk"
				else:
					if (is_touching_right_wall() and is_facing_right) or (is_touching_left_wall() and not is_facing_right):
						animations.animation = "On Wall"
					elif velocity.y <= 0:
						animations.animation = "Jump"
					else:
						animations.animation = "Fall"
	
	if not animations.is_playing():
		animations.play()
	if move_state == MoveState.FLIGHT:
		animations.sprite_frames = sprite_frames[4]
	elif spark_progress > 3.0:
		animations.sprite_frames = sprite_frames[3]
	elif spark_progress > 2.0:
		animations.sprite_frames = sprite_frames[2]
	elif spark_progress > 1.0:
		animations.sprite_frames = sprite_frames[1]
	else:
		animations.sprite_frames = sprite_frames[0]

func setup_keybinds(player_number: int) -> void:
	var player_input: String = "p" + str(player_number) + "_"
	jump_action = player_input + "jump"
	move_left_action = player_input + "left"
	run_modifier_action = player_input + "run"
	move_right_action = player_input + "right"
	dash_action = player_input + "run"
	roll_action = player_input + "run"
	down_action = player_input + "crouch"

func test_wall_direction(distance: float):
	return test_move(transform, Vector2(distance, 0))

func snap_wall_direction(distance: float):
	move_and_collide(Vector2(distance, 0))

func dash_timer_end() -> void:
	move_state = MoveState.NORMAL

func rebound_timer_end() -> void:
	move_state = MoveState.NORMAL

func flight_timer_end() -> void:
	move_state = MoveState.NORMAL
	spark_progress = 0.0

func dash_buffer_end() -> void:
	if move_state == MoveState.NORMAL:
		do_roll()

func re_dash_timer_end() -> void:
	can_dash = true

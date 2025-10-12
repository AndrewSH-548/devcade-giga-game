extends Player

@onready var normal_collision: CollisionShape2D = $NormalCollision
@onready var roll_collision: CollisionShape2D = $RollCollision

@onready var dash_timer: Timer = $Timers/Dash
@onready var rebound_timer: Timer = $Timers/Rebound
@onready var flight_timer: Timer = $Timers/Flight
@onready var re_dash_timer: Timer = $Timers/ReDash

@onready var dash_buffer_timer: Timer = $Timers/DashBuffer

@onready var animations: AnimatedSprite2D = $Animations
@onready var spark_animation: AnimatedSprite2D = $Spark

const FRAMES_COLD = preload("uid://dyusrrvvi0kwy")
const FRAMES_HEATED = preload("uid://bhpx81eanaqud")
const FRAMES_HOT = preload("uid://dkxtgcsyxa6ll")
const FRAMES_SCORCHING = preload("uid://ccktww0200aun")
const FRAMES_FLIGHT = preload("uid://qx7wdomqsg3r")

var dash_action: StringName
var roll_action: StringName

var dash_speed: float = 512.0
var dash_time: float = 0.13
var dash_buffer_time: float = 0.2
var can_dash: bool = true
var re_dash_time: float = 0.5

var rebound_direction: int = 1
var rebound_time: float = 0.3
var rebound_pushoff_strength: float = 90.0
var rebound_boost_strength: float = 200.0
var rebound_leeway: float = 16.0

var spark_progress: float = 0.0
var rebound_spark_amount: float = 1.3
var spark_drain_per_second: float = 0.0

var flight_speed: float = 800.0
var flight_time: float = 0.5
var flight_offset_x: float = 32.0
var flight_target_x: float
var flight_gravity: float = 900.0

var roll_speed: float = 320.0
var roll_gravity: float = 1200.0
var roll_bounce_strength: float = 256.0

var on_floor_last_frame: bool = false

var move_state: MoveState = MoveState.NORMAL

enum MoveState {
	NORMAL,
	ROLL,
	DASH,
	REBOUND,
	FLIGHT,
}

func _physics_process(delta: float) -> void:
	var header = get_tree().get_first_node_in_group("splitscreen")
	if header != null and header.paused:
		return
		
	var direction: float = get_horizontal_movement()
	
	spark_progress = move_toward(spark_progress, 0.0, spark_drain_per_second * delta)
	
	if move_state != MoveState.NORMAL:
		if Input.is_action_just_pressed(dash_action):
			dash_buffer_timer.start(dash_buffer_time)
	
	if get_position_state() != STATE_HITSTUN:
		match move_state:
			MoveState.NORMAL:
				process_walkrun(delta, direction)
				process_gravity(delta)
				process_jump(delta)
				process_walljump(delta)
				if Input.is_action_just_pressed(roll_action):
					do_roll()
			# SCRAPPED DASH, WAS REPLACED BY ROLL
			#MoveState.DASH:
			#	process_dash()
			MoveState.REBOUND:
				process_rebound()
				process_gravity(delta)
			MoveState.FLIGHT:
				process_flight(delta)
			MoveState.ROLL:
				process_roll(delta)
	else:
		move_state = MoveState.NORMAL
	
	if move_state != MoveState.ROLL:
		update_flipped()
	animate_flare()
	
	on_floor_last_frame = is_on_floor()
	move_and_slide()

func do_dash():
	move_state = MoveState.DASH
	dash_timer.start(dash_time)
	can_dash = false
	re_dash_timer.start(re_dash_time)

func do_rebound(wall_direction: int):
	can_dash = true
	move_state = MoveState.REBOUND
	dash_timer.stop()
	spark_progress += rebound_spark_amount
	spark_animation.play()
	animations.play("Roll")
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
	animations.play("Roll")
	move_state = MoveState.ROLL

func process_dash():
	var facing: int = 1 if isFacingRight else -1
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
	var facing: int = 1 if isFacingRight else -1
	velocity.x = facing * roll_speed
	velocity.y += roll_gravity * delta
	
	if is_on_floor():
		update_flipped()
		velocity.y = -roll_bounce_strength
	
	if is_on_floor() and not on_floor_last_frame:
		spark_progress += rebound_spark_amount
		spark_animation.play()
	
	if test_wall_direction(facing * rebound_leeway):
		snap_wall_direction(facing * rebound_leeway)
		do_rebound(-facing)

func animate_flare():
	sprite.flip_h = !isFacingRight
	
	if get_position_state() == STATE_HITSTUN:
		if animations.animation != "Hitstun":
			animations.play("Hitstun")
	else:
		if animations.animation == "Hitstun":
			animations.play("Idle")
	
	if not animations.is_playing():
		animations.play()
	if move_state == MoveState.FLIGHT:
		animations.sprite_frames = FRAMES_FLIGHT
	elif spark_progress > 3.0:
		animations.sprite_frames = FRAMES_SCORCHING
	elif spark_progress > 2.0:
		animations.sprite_frames = FRAMES_HOT
	elif spark_progress > 1.0:
		animations.sprite_frames = FRAMES_HEATED
	else:
		animations.sprite_frames = FRAMES_COLD

func setup_keybinds(player_number: int) -> void:
	var player_input: String = "p" + str(player_number) + "_"
	jump_action = player_input + "jump"
	move_left_action = player_input + "left"
	run_modifier_action = player_input + "run"
	move_right_action = player_input + "right"
	dash_action = player_input + "run"
	roll_action = player_input + "run"

func test_wall_direction(distance: float):
	return test_move(transform, Vector2(distance, 0))

func snap_wall_direction(distance: float):
	move_and_collide(Vector2(distance, 0))

func dash_timer_end() -> void:
	move_state = MoveState.NORMAL

func rebound_timer_end() -> void:
	move_state = MoveState.NORMAL
	animations.play("Idle")

func flight_timer_end() -> void:
	move_state = MoveState.NORMAL
	spark_progress = 0.0
	animations.play("Idle")

func dash_buffer_end() -> void:
	if move_state == MoveState.NORMAL:
		do_roll()

func re_dash_timer_end() -> void:
	can_dash = true

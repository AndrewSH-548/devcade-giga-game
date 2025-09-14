extends CharacterBody2D

# Export stats
@export var walk_speed: int
@export var run_speed: int
@export var deccel: int = 50
@export var air_speed: int
@export var air_accel: int
@export var jump_height: int
@export var wall_jump_height: int
@export var wall_pushoff_strength: int
@export var fall_speed: int
@export var gravity: int
@export var weight: int

@export var jump_action: String = " "
@export var move_left_action: String = " "
@export var move_right_action: String = " "
@export var run_modifier_action: String = " "

var acceleration: float = 0
var hitstun: bool = false

var sprite: AnimatedSprite2D
var isFacingRight: bool = true

const JUMP_BUFFER_TIME: float = 0.2
const COYOTE_TIME: float = 0.07

@onready var jump_buffer_timer: Timer = make_timer(JUMP_BUFFER_TIME)
@onready var coyote_timer: Timer = make_timer(COYOTE_TIME)
var has_done_coyote: bool = true

enum {
	STATE_ON_FLOOR,
	STATE_ON_WALL,
	STATE_IN_AIR,
	STATE_HITSTUN,
}

func _ready() -> void:
	sprite = $Animations
	sprite.play();

func make_timer(time: float) -> Timer:
	var timer: Timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = time
	add_child(timer)
	return timer

func get_position_state() -> int:
	if hitstun: return STATE_HITSTUN
	if is_on_floor(): return STATE_ON_FLOOR
	if is_on_wall(): return STATE_ON_WALL
	return STATE_IN_AIR

func process_gravity(delta: float):
	# Add the gravity.
	if get_position_state() in [STATE_ON_WALL, STATE_IN_AIR, STATE_HITSTUN]:
		velocity.y += gravity * delta;
		velocity.y = clamp(velocity.y, -jump_height, fall_speed);

func process_jump(delta: float):
	if get_position_state() == STATE_ON_FLOOR:
		coyote_timer.stop()
		has_done_coyote = false
	if get_position_state() == STATE_IN_AIR and coyote_timer.is_stopped() and not has_done_coyote:
		coyote_timer.start()
		has_done_coyote = true
	# Handle jump
	if Input.is_action_just_pressed(jump_action):
		if get_position_state() == STATE_ON_FLOOR:
			velocity.y = -jump_height
		elif get_position_state() == STATE_IN_AIR and not coyote_timer.is_stopped():
			velocity.y = -jump_height
			has_done_coyote = true
			coyote_timer.stop()

func horizontal_movement_process_old(delta: float, direction: float):
	# Move, and check whether the player in in hitstun
	if direction:
		
		# ON WALL
		if Input.is_action_just_pressed(jump_action) and is_on_wall() and !is_on_floor() and not hitstun:
			velocity.x = -direction * wall_jump_height / 1.8
			velocity.y = -wall_jump_height
		
		# IN AIR OR WALL
		elif !is_on_floor() and not hitstun:
			if abs(velocity.x) < air_speed:
				velocity.x += direction * air_accel
			else:
				velocity.x = move_toward(velocity.x, direction*air_speed, air_accel);
		
		# ON FLOOR RUN
		elif Input.is_action_pressed(run_modifier_action) and not hitstun:
			velocity.x = direction * run_speed;
		# ON FLOOR WALK
		elif not hitstun:
			velocity.x = direction * walk_speed;
	
	else:
		velocity.x = move_toward(velocity.x, 0, deccel)

func process_walkrun(delta: float, direction: float) -> void:
	# Deccelerate if there is no input
	if direction == 0.0:
		velocity.x = move_toward(velocity.x, 0, deccel)
	# Other, run this if there IS input
	else:
		# Do different things based on the state...
		match get_position_state():
			
			# FLOOR WALK/RUN State
			STATE_ON_FLOOR:
				if Input.is_action_pressed(run_modifier_action):
					velocity.x = direction * run_speed
				else:
					velocity.x = direction * walk_speed
				
			# AIR and WALL WALK/RUN State
			STATE_IN_AIR, STATE_ON_WALL:
				if abs(velocity.x) < air_speed:
					velocity.x += direction * air_accel
				else:
					velocity.x = move_toward(velocity.x, direction*air_speed, air_accel)

func process_walljump(delta: float) -> void:
	# Skip this if the player is not wallsliding
	# Look at get_position_state() and STATE_ON_WALL for wallsliding conditions
	if get_position_state() != STATE_ON_WALL: return
	
	if Input.is_action_just_pressed(jump_action):
		velocity.x = get_pushoff_wall_direction() * wall_pushoff_strength
		velocity.y = -wall_jump_height

func get_pushoff_wall_direction() -> float:
	# The Wall Normal is a Vector2 which points away from the wall
	var wall_normal: Vector2 = get_wall_normal()
	# If there's a left wall, return -1.0
	if wall_normal.dot(Vector2.LEFT) > 0.3:
		return -1.0
	# If there's a right wall, return 1.0
	if wall_normal.dot(Vector2.RIGHT) > 0.3:
		return 1.0
	# If there's two walls or some other weirdness, return 0.0
	return 0.0

func get_horizontal_movement() -> float:
	return Input.get_axis(move_left_action, move_right_action)

func update_flipped() -> void:
	if Input.is_action_just_pressed(move_left_action) and isFacingRight:
		isFacingRight = false;
	elif Input.is_action_just_pressed(move_right_action) and not isFacingRight:
		isFacingRight = true;

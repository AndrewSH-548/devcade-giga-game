@abstract
extends CharacterBody2D
class_name Player

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

@onready var hitbox: Area2D = $Hitbox

var jump_action: String = " "
var move_left_action: String = " "
var move_right_action: String = " "
var run_modifier_action: String = " "
var down_action: String = " "

var acceleration: float = 0
var hitstun: bool = false

var sprite: AnimatedSprite2D
var is_facing_right: bool = true
var facing: int:
	get(): return 1 if is_facing_right else -1

var disable_decceleration: bool = false
var deccel_disable_timer: Timer = Timer.new()

var disable_walk_input: bool = false
var walk_input_disable_timer: Timer= Timer.new()

var on_wall_last_frame: bool = false

var halt_physics: bool = false
var physics_multiplier: float = 1.0

var walk_speed_frame_modifier_directional: float = 1.0

var foot_offset: Vector2
var foot_global_position: Vector2:
	get(): return global_position + foot_offset
	set(new): global_position = new - foot_offset

const JUMP_BUFFER_TIME: float = 0.1
const COYOTE_TIME: float = 0.07
const WALL_JUMP_COYOTE_TIME: float = 0.1
const WALL_JUMP_BUFFER_TIME: float = 0.07
const HITSTUN_TIME: float = 1.7
const INVINCIBILITY_TIME: float = 2.3

const LAYER_NOT_HITSTUN: int = 128

@onready var jump_buffer_timer: Timer = make_timer(JUMP_BUFFER_TIME)
@onready var coyote_timer: Timer = make_timer(COYOTE_TIME)
@onready var wall_jump_coyote_timer: Timer = make_timer(WALL_JUMP_COYOTE_TIME)
@onready var wall_jump_buffer_timer: Timer = make_timer(WALL_JUMP_BUFFER_TIME)
@onready var invincibility_timer: Timer = make_timer(INVINCIBILITY_TIME)

var has_done_coyote: bool = true

enum {
	STATE_ON_FLOOR,
	STATE_ON_WALL,
	STATE_IN_AIR,
	STATE_HITSTUN,
}

@abstract func setup_keybinds(player_number: int) -> void

func _ready() -> void:
	deccel_disable_timer.one_shot = true
	walk_input_disable_timer.one_shot = true
	add_child(deccel_disable_timer)
	add_child(walk_input_disable_timer)
	deccel_disable_timer.timeout.connect(func(): disable_decceleration = false)
	walk_input_disable_timer.timeout.connect(func(): disable_walk_input = false)
	sprite = $Animations
	sprite.play();
	hitbox.area_entered.connect(func(body): do_hitstun(body))
	# Collide with LAYER_NOT_HITSTUN
	collision_mask |= LAYER_NOT_HITSTUN

func make_timer(time: float) -> Timer:
	var timer: Timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = time
	add_child(timer)
	return timer

func disable_decceleration_timed(time: float) -> void:
	disable_decceleration = true
	deccel_disable_timer.start(time)

func disable_walk_input_timed(time: float) -> void:
	disable_walk_input = true
	walk_input_disable_timer.start(time)

func get_position_state() -> int:
	if hitstun: return STATE_HITSTUN
	if is_on_floor(): return STATE_ON_FLOOR
	if is_touching_wall(): return STATE_ON_WALL
	return STATE_IN_AIR

func is_invincible() -> bool:
	return not invincibility_timer.is_stopped()

func move() -> void:
	velocity *= physics_multiplier
	move_and_slide()
	velocity /= physics_multiplier
	physics_multiplier = 1.0

func _process(_delta: float) -> void:
	if is_invincible():
		var time: float = Time.get_ticks_msec() / 1000.0
		modulate.a = 0.8 if int(time * 20.0) % 2 == 0 else 0.5
	else:
		modulate.a = 1.0

func process_gravity(delta: float):
	# Add the gravity.
	if get_position_state() in [STATE_ON_WALL, STATE_IN_AIR, STATE_HITSTUN]:
		velocity.y += gravity * delta
		velocity.y = min(velocity.y, fall_speed)

func process_jump(_delta: float):
	
	# If there is a jump in the buffer, and the player is on the floor, JUMP!
	if get_position_state() == STATE_ON_FLOOR and not jump_buffer_timer.is_stopped():
		do_jump()
		jump_buffer_timer.stop()
	
	# When on floor, stop the coyote timer and allow the player to coyote again
	if get_position_state() == STATE_ON_FLOOR:
		coyote_timer.stop()
		has_done_coyote = false
	# Start the coyote timer if the player just left the ground
	if get_position_state() == STATE_IN_AIR and coyote_timer.is_stopped() and not has_done_coyote:
		coyote_timer.start()
		has_done_coyote = true
	# If the player presses jump...
	if Input.is_action_just_pressed(jump_action):
		# Normal Jump on floor
		if get_position_state() == STATE_ON_FLOOR:
			do_jump()
		# If in the air, and the player only recently left the ground, allow a mid-air jump
		elif get_position_state() == STATE_IN_AIR and not coyote_timer.is_stopped():
			do_jump()
			has_done_coyote = true
			coyote_timer.stop()
		# If the player couldn't jump, save a jump into buffer for JUMP_BUFFER_TIME
		else:
			jump_buffer_timer.start()

func do_jump() -> void:
	velocity.y = -jump_height

func is_touching_wall():
	return is_touching_left_wall() or is_touching_right_wall()

func is_touching_left_wall() -> bool:
	return test_move(transform, Vector2(-2, 0))

func is_touching_right_wall() -> bool:
	return test_move(transform, Vector2(2, 0))

func process_walkrun(delta: float, direction: float) -> void:
	
	if get_position_state() == STATE_HITSTUN:
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0, deccel * delta * 60)
		
		return
	
	var walk_modifier: float = walk_speed_frame_modifier_directional
	walk_speed_frame_modifier_directional = 1.0
	
	if walk_modifier != 1.0:
		if sign(direction) == sign(walk_modifier):
			direction *= abs(walk_modifier)
		if sign(direction) == -sign(walk_modifier):
			if(walk_modifier != 0.0):
				direction /= abs(walk_modifier)
	
	# Deccelerate if there is no input
	if (direction == 0.0 or disable_walk_input or get_position_state() == STATE_HITSTUN) and not disable_decceleration:
		velocity.x = move_toward(velocity.x, 0, deccel * delta * 60)
	# Other, run this if there IS input
	elif not disable_walk_input:
		# Do different things based on the state...
		match get_position_state():
			
			# FLOOR WALK/RUN State
			STATE_ON_FLOOR:
				if direction == 0.0 and disable_decceleration:
					return
				if Input.is_action_pressed(run_modifier_action):
					velocity.x = direction * run_speed
				else:
					velocity.x = direction * walk_speed
				
			# AIR and WALL WALK/RUN State
			STATE_IN_AIR, STATE_ON_WALL:
				if abs(velocity.x) < air_speed:
					velocity.x += direction * air_accel * delta * 60
				else:
					var target_speed: float = direction * air_speed
					if disable_decceleration:
						# Skip air decceration if decceleration is disabled
						if direction == 0.0:
							return
						# Don't lower air speed if decceleration is disabled and direction is the same as the direction of velocity
						if sign(target_speed) == sign(velocity.x) and abs(velocity.x) > abs(target_speed):
							return
					velocity.x = move_toward(velocity.x, target_speed, air_accel * delta * 60)

func process_wallcheck(_delta: float) -> void:
	
	if on_wall_last_frame and get_position_state() != STATE_ON_WALL:
		wall_jump_coyote_timer.start()
	
	on_wall_last_frame = get_position_state() == STATE_ON_WALL

func process_walljump(_delta: float) -> void:
	# Skip this if the player is not wallsliding
	# Look at get_position_state() and STATE_ON_WALL for wallsliding conditions
	if get_position_state() != STATE_ON_WALL and wall_jump_coyote_timer.is_stopped():
		if Input.is_action_just_pressed(jump_action) and not get_position_state() == STATE_ON_FLOOR:
			jump_buffer_timer.start()
		return
	
	if Input.is_action_just_pressed(jump_action) or not jump_buffer_timer.is_stopped():
		do_walljump()

func do_walljump() -> void:
	velocity.x = get_pushoff_wall_direction() * wall_pushoff_strength 
	velocity.y = -wall_jump_height
	wall_jump_coyote_timer.stop()
	wall_jump_buffer_timer.stop()

func do_hitstun(body: Obstacle) -> void:
	if is_invincible():
		return
	if body is not Obstacle:
		return
	if hitstun:
		return
	velocity = body.get_launch_velocity(self)
	invincibility_timer.start()
	hitstun = true
	# Don't Collide with LAYER_NOT_HITSTUN (Depricated)
	#collision_mask &= ~LAYER_NOT_HITSTUN
	disable_walk_input = true
	# Create hitstun effect (time can be changed (currently 1 second))
	# DO Collide with LAYER_NOT_HITSTUN
	await get_tree().create_timer(HITSTUN_TIME).timeout
	#collision_mask |= LAYER_NOT_HITSTUN
	disable_walk_input = false
	hitstun = false

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
	if Input.is_action_pressed(move_right_action) and Input.is_action_pressed(move_left_action):
		return
	if Input.is_action_pressed(move_left_action) and is_facing_right:
		is_facing_right = false
	elif Input.is_action_pressed(move_right_action) and not is_facing_right:
		is_facing_right = true

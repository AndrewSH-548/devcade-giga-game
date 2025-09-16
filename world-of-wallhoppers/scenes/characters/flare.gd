extends "res://assets/scripts/player.gd"

@onready var normal_collision: CollisionShape2D = $NormalCollision
@onready var roll_collision: CollisionShape2D = $RollCollision

@export var kick_strength: float = 200
@export var boost_strength: float = 400
@export var roll_bounce_strength: float = 200
@export var roll_gravity: float = 900
@export var kick_action: StringName
@export var hitstun_movement: float = 20

enum {
	MOVE_NORMAL,
	MOVE_ROLL,
}

var move_state: int = MOVE_NORMAL

func _physics_process(delta: float) -> void:
	if get_tree().get_first_node_in_group("splitscreen").paused:
		return
	
	var direction := get_horizontal_movement()
	
	if get_position_state() == STATE_HITSTUN:
		move_state = MOVE_NORMAL
	
	if move_state == MOVE_NORMAL:
		update_flipped()
		process_gravity(delta)
	else:
		if get_position_state() in [STATE_ON_WALL, STATE_IN_AIR, STATE_HITSTUN]:
			velocity.y += roll_gravity * delta;
	
	# Jump if on floor
	if get_position_state() == STATE_ON_FLOOR:
		match move_state:
			MOVE_NORMAL:
				do_jump()
			MOVE_ROLL:
				velocity.y = -roll_bounce_strength
	
	process_kick(delta)
	
	if move_state == MOVE_NORMAL:
		process_walkrun(delta, direction)
		process_walljump(delta)
		if get_position_state() == STATE_HITSTUN:
			var facing: int = -1 if isFacingRight else 1
			velocity.x = hitstun_movement * facing
	else:
		process_roll(delta)
	
	animate_flare()
	
	move_and_slide()

func process_kick(delta: float):
	
	match move_state:
		MOVE_NORMAL:
			normal_collision.disabled = false
			roll_collision.disabled = true
		MOVE_ROLL:
			normal_collision.disabled = true
			roll_collision.disabled = false
	
	var facing: int = 1 if isFacingRight else -1
	
	if move_state == MOVE_ROLL and get_position_state() == STATE_ON_WALL:
		velocity.y = -boost_strength
		move_state = MOVE_NORMAL
	
	if move_state == MOVE_NORMAL and Input.is_action_pressed(kick_action) and get_position_state() != STATE_HITSTUN:
		velocity.x = kick_strength * facing
		move_state = MOVE_ROLL

func process_roll(delta: float):
	var facing: int = 1 if isFacingRight else -1
	velocity.x = kick_strength * facing

func animate_flare():
	sprite.flip_h = !isFacingRight
	
	if get_position_state() == STATE_HITSTUN:
		sprite.animation = "Hitstun"
		return
	
	match move_state:
		MOVE_NORMAL:
			sprite.animation = "Idle"
		MOVE_ROLL:
			sprite.animation = "Roll"

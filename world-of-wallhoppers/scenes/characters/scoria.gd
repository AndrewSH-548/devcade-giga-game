extends Player

@onready var normal_collision: CollisionShape2D = $NormalCollision
@onready var roll_collision: CollisionShape2D = $RollCollision

@export var kick_strength: float = 200.0
@export var boost_strength: float = 400.0
@export var roll_bounce_strength: float = 200.0
@export var roll_gravity: float = 900.0
@export var kick_action: StringName
@export var hitstun_movement: float = 20.0
@export var roll_rebound_strength: float = 420.0
@export var roll_rebound_decceleration: float = 0.7

enum {
	MOVE_NORMAL,
	MOVE_REBOUND,
	MOVE_ROLL,
	MOVE_BURN_BOOST,
}

enum {
	NORMAL,
	FIRST_BUMP,
	FLARE_STAGE_1,
	FLARE_STAGE_2,
	BURNING,
}

var flare_state: int = NORMAL
var move_state: int = MOVE_NORMAL

func _physics_process(delta: float) -> void:
	var header = get_tree().get_first_node_in_group("splitscreen")
	if header != null and header.paused:
		return
	
	var direction: float = get_horizontal_movement()
	var POSITION_STATE: int = get_position_state()
	
	match move_state:
		MOVE_NORMAL:
			
			normal_collision.disabled = false
			roll_collision.disabled = true
			
			if Input.is_action_pressed(kick_action) and POSITION_STATE != STATE_HITSTUN:
				move_state = MOVE_ROLL
			
			update_flipped()
			process_gravity(delta)
			
			process_walkrun(delta, direction)
			process_walljump(delta)
			if get_position_state() == STATE_HITSTUN:
				var facing: int = -1 if isFacingRight else 1
				velocity.x = hitstun_movement * facing
			
		MOVE_ROLL:
			
			normal_collision.disabled = true
			roll_collision.disabled = false
			
			process_roll(delta)
			
			if POSITION_STATE in [STATE_ON_WALL, STATE_IN_AIR, STATE_HITSTUN]:
				velocity.y += roll_gravity * delta;
			
			if POSITION_STATE == STATE_ON_FLOOR:
				kickstart()
				velocity.y = -roll_bounce_strength
	
	animate_flare()
	move_and_slide()

func kickstart():
	print("KICK!")
	match flare_state:
		NORMAL: flare_state = FIRST_BUMP
		FIRST_BUMP: flare_state = FLARE_STAGE_1
		FLARE_STAGE_1: flare_state = FLARE_STAGE_2
		FLARE_STAGE_2: flare_state = BURNING


func process_roll(_delta: float):
	var facing: int = 1 if isFacingRight else -1
	velocity.x = kick_strength * facing
	
	if get_position_state() == STATE_ON_WALL:
		kickstart()
		if flare_state == BURNING:
			velocity.y = -boost_strength
			move_state = MOVE_BURN_BOOST
		else:
			move_state = MOVE_REBOUND

func process_rebound(_delta: float):
	pass

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

func setup_keybinds(player_number: int) -> void:
	var player_input: String = "p" + str(player_number) + "_"
	jump_action = player_input + "jump"
	move_left_action = player_input + "left"
	run_modifier_action = player_input + "run"
	move_right_action = player_input + "right"
	kick_action = player_input + "run"

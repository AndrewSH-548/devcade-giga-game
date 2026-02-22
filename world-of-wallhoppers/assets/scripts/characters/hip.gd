extends Player
class_name PlayerHip

var crouch_action: String = " "
var is_wall_climbing: bool = false

@export var climb_speed: float
@onready var foot_position_marker: Marker2D = $FootPositionMarker

func _ready() -> void:
	foot_offset = foot_position_marker.global_position - global_position
	super._ready()

func _physics_process(delta: float) -> void:
	var header = get_tree().get_first_node_in_group("LevelHeader")
	if header != null and header.paused:
		return
	if halt_physics:
		return
	
	var modified_delta: float = get_modified_delta(delta)
	
	# Set is_wall_climbing to true if Wallsliding and the run button is pressed
	is_wall_climbing = Input.is_action_pressed(run_modifier_action) and get_position_state() == STATE_ON_WALL
	
	var direction: float = get_horizontal_movement()
	
	# Don't do gravity when wallclibing
	if not is_wall_climbing: process_gravity(modified_delta)
	process_jump(modified_delta)
	
	update_flipped()
	
	if not is_wall_climbing: process_walkrun(modified_delta, direction)
	process_walljump_hip(modified_delta)
	animate_hip(direction)
	process_wallclimb()
	
	move(delta, modified_delta)

func get_climb_input():
	return Input.get_axis(jump_action, crouch_action)

func process_wallclimb():
	if is_wall_climbing:
		var climbDirection: float = get_climb_input()
		velocity.y = climbDirection * climb_speed;

func process_walljump_hip(delta: float) -> void:
	process_wallcheck(delta)
	# Skip walljump processing if currently wallclimbing
	if is_wall_climbing: return
	process_walljump(delta)

func update_flipped() -> void:
	var left_wall: bool = is_touching_left_wall()
	var right_wall: bool = is_touching_right_wall()
	if (left_wall or right_wall) and not is_on_floor():
		if left_wall: is_facing_right = false
		if right_wall: is_facing_right = true
	else:
		super.update_flipped()

func animate_hip(direction: float) -> void:
	if hitstun:
		sprite.animation = "hurt"
	elif is_touching_wall() and not is_on_floor():
		sprite.animation = "wall-climb" if is_wall_climbing else "wall-cling"
	elif velocity.y < 0:
		sprite.animation = "jump"
	elif get_position_state() == STATE_IN_AIR:
		sprite.animation = "fall"
	elif is_touching_wall() && direction != 0:
		sprite.animation = "wall-push"
	elif direction != 0:
		sprite.animation = "run" if Input.is_action_pressed(run_modifier_action) else "walk"
	else: sprite.animation = "idle"
	
	sprite.flip_h = !is_facing_right;

func setup_keybinds(player_number: int) -> void:
	var player_input: String = "p" + str(player_number) + "_"
	jump_action = player_input + "jump"
	crouch_action = player_input + "crouch"
	move_left_action = player_input + "left"
	run_modifier_action = player_input + "run"
	move_right_action = player_input + "right"

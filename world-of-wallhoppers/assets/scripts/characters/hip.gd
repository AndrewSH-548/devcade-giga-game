extends Player
class_name PlayerHip

var crouch_action: String = " "
var is_wall_climbing: bool = false

@export var climb_speed: float
@onready var foot_position_marker: Marker2D = $FootPositionMarker

var frame_climb_speed_modifier: float = 1.0
var frame_climb_velocity_addition: float = 0.0

func _ready() -> void:
	foot_offset = foot_position_marker.global_position - global_position
	super._ready()

func _physics_process(delta: float) -> void:
	var header = get_tree().get_first_node_in_group("LevelHeader")
	if header != null and header.paused:
		return
	if halt_physics:
		return
	
	# Set is_wall_climbing to true if Wallsliding and the run button is pressed
	is_wall_climbing = Input.is_action_pressed(run_modifier_action) and get_position_state() == STATE_ON_WALL
	
	var direction: float = get_horizontal_movement()
	
	# Don't do gravity when wallclibing
	if not is_wall_climbing: process_gravity(delta)
	process_jump(delta)
	
	update_flipped()
	
	if not is_wall_climbing: process_walkrun(delta, direction)
	process_walljump_hip(delta)
	animate_hip(direction)
	process_wallclimb()
	
	move_and_slide()

func get_climb_input():
	return Input.get_axis(jump_action, crouch_action)

func process_wallclimb():
	if not is_wall_climbing:
		return
	
	var climb_modifier: float = frame_climb_speed_modifier
	var climb_addition: float = frame_climb_velocity_addition
	frame_climb_speed_modifier = 1.0
	frame_climb_velocity_addition = 0.0
	
	var climb_direction: float = get_climb_input()
	
	if climb_modifier != 1.0:
		if sign(climb_direction) == sign(climb_modifier):
			climb_direction *= abs(climb_modifier)
		if sign(climb_direction) == -sign(climb_modifier):
			if(climb_modifier != 0.0):
				climb_direction /= abs(climb_modifier)
	
	velocity.y = climb_direction * climb_speed + climb_addition;

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
		if not is_wall_climbing:
			sprite.animation = "wall-cling"
		else:
			sprite.animation = "wall-climb"
			# Freeze the animation at frame 0 if there's no climb input
			if get_climb_input() == 0.0:
				sprite.frame = 0
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

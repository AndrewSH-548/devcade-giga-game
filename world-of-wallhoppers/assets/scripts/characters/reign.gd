extends Player
class_name PlayerReign

var is_hovering: bool = false;

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
	
	is_hovering = Input.is_action_pressed(run_modifier_action) and get_position_state() in [STATE_IN_AIR, STATE_ON_WALL];
	
	var direction := get_horizontal_movement()
	
	process_hover(modified_delta)
	update_flipped()
	process_walkrun(modified_delta, direction)
	animate_reign(direction)

	move(delta, modified_delta)

func process_hover(delta: float) -> void: 
	if Input.is_action_just_pressed(run_modifier_action) and get_position_state() in [STATE_IN_AIR, STATE_ON_WALL]:
		velocity.y = 0;
	if is_hovering: velocity.y = clamp(velocity.y - delta, 0, fall_speed);
	else:
		process_gravity(delta)
		process_jump(delta)
		process_wallcheck(delta)
		process_walljump(delta)

func animate_reign(direction: float) -> void:
	sprite.flip_h = false;
	if hitstun:
		sprite.animation = "hurt" if is_facing_right else "hurt-left";
	elif get_position_state() == STATE_ON_WALL:
		sprite.flip_h = true;
		sprite.animation = "wall-cling-left" if is_facing_right else "wall-cling";
	elif is_hovering:
		sprite.animation = "run" if is_facing_right else "run-left";
	elif velocity.y < 0 :
		sprite.animation = "jump" if is_facing_right else "jump-left";
	elif get_position_state() == STATE_IN_AIR:
		sprite.animation = "fall" if is_facing_right else "fall-left";
	elif is_touching_wall() && direction != 0:
		sprite.animation = "wall-push" if is_facing_right else "wall-push-left";
	elif direction != 0:
		if Input.is_action_pressed(run_modifier_action):
			sprite.animation = "run" if is_facing_right else "run-left" 
		else: sprite.animation = "walk" if is_facing_right else "walk-left";
	else: sprite.animation = "idle" if is_facing_right else "idle-left";
	

func setup_keybinds(player_number: int) -> void:
	var player_input: String = "p" + str(player_number) + "_"
	jump_action = player_input + "jump"
	move_left_action = player_input + "left"
	run_modifier_action = player_input + "run"
	move_right_action = player_input + "right"

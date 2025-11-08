extends Player
class_name PlayerReign

var is_hovering: bool = false;

func _physics_process(delta: float) -> void:
	var header = get_tree().get_first_node_in_group("splitscreen")
	if header != null and header.paused:
		return
	
	is_hovering = Input.is_action_pressed(run_modifier_action) and get_position_state() in [STATE_IN_AIR, STATE_ON_WALL];
	
	var direction := get_horizontal_movement()
	
	process_hover(delta)
	update_flipped()
	process_walkrun(delta, direction)
	animate_reign(direction)

	move_and_slide()

func process_hover(delta: float) -> void: 
	if Input.is_action_just_pressed(run_modifier_action) and get_position_state() in [STATE_IN_AIR, STATE_ON_WALL]:
		velocity.y = 0;
	if is_hovering: velocity.y = clamp(velocity.y - delta, 0, fall_speed);
	else:
		process_gravity(delta)
		process_jump(delta)
		process_walljump(delta)

func animate_reign(direction: float) -> void:
	if hitstun:
		sprite.animation = "hurt";
	elif get_position_state() == STATE_ON_WALL:
		sprite.animation = "wall-cling";
	elif is_hovering:
		sprite.animation = "run";
	elif velocity.y < 0 :
		sprite.animation = "jump";
	elif get_position_state() == STATE_IN_AIR:
		sprite.animation = "fall";
	elif is_touching_wall() && direction != 0:
		sprite.animation = "wall-push";
	elif direction != 0:
		sprite.animation = "run" if Input.is_action_pressed(run_modifier_action) else "walk";
	else: sprite.animation = "idle";
	
	sprite.flip_h = !isFacingRight;

func setup_keybinds(player_number: int) -> void:
	var player_input: String = "p" + str(player_number) + "_"
	jump_action = player_input + "jump"
	move_left_action = player_input + "left"
	run_modifier_action = player_input + "run"
	move_right_action = player_input + "right"

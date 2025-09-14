extends "res://assets/scripts/player.gd"

var is_hovering: bool = false;

func _physics_process(delta: float) -> void:
	if get_tree().get_first_node_in_group("splitscreen").paused:
		return
	
	is_hovering = Input.is_action_pressed(run_modifier_action) and get_position_state() == STATE_IN_AIR;
	
	var direction := get_horizontal_movement()
	
	process_gravity(delta)
	process_jump(delta)
	update_flipped()
	process_walkrun(delta, direction)
	process_walljump(delta)
	animate_reign(direction)

	move_and_slide()

func process_gravity(delta: float) -> void:
	# Add the gravity.
	if not is_hovering: 
		super.process_gravity(delta);
		return;
		
	if get_position_state() in [STATE_ON_WALL, STATE_IN_AIR, STATE_HITSTUN]:
		velocity.y += gravity * delta * 0.3;
		velocity.y = clamp(velocity.y, -jump_height, fall_speed);

func animate_reign(direction: float) -> void:
	if hitstun:
		sprite.animation = "hurt";
	elif is_on_wall() and not is_on_floor():
		sprite.animation = "wall-cling";
	elif velocity.y < 0:
		sprite.animation = "jump";
	elif not is_on_wall() and not is_on_floor():
		sprite.animation = "fall";
	elif is_on_wall() && direction != 0:
		sprite.animation = "wall-push";
	elif direction != 0:
		sprite.animation = "run" if Input.is_action_pressed(run_modifier_action) else "walk";
	else: sprite.animation = "idle";
	
	sprite.flip_h = !isFacingRight;

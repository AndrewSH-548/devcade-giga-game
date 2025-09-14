extends "res://assets/scripts/player.gd"

func _physics_process(delta: float) -> void:
	if get_tree().get_first_node_in_group("splitscreen").paused:
		return
	
	var direction := get_horizontal_movement()
	
	process_gravity(delta)
	process_jump(delta)
	update_flipped()
	process_walkrun(delta, direction)
	process_walljump(delta)
	animate_reign(direction)

	move_and_slide()

func animate_reign(direction: float) -> void:
	if hitstun:
		sprite.animation = "hurt";
	elif get_position_state() == STATE_ON_WALL:
		sprite.animation = "wall-cling";
	elif velocity.y < 0:
		sprite.animation = "jump";
	elif get_position_state() == STATE_IN_AIR:
		sprite.animation = "fall";
	elif is_touching_wall() && direction != 0:
		sprite.animation = "wall-push";
	elif direction != 0:
		sprite.animation = "run" if Input.is_action_pressed(run_modifier_action) else "walk";
	else: sprite.animation = "idle";
	
	sprite.flip_h = !isFacingRight;

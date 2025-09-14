extends "res://assets/scripts/player.gd"

@export var crouch_action: String = " "
var is_wall_climbing: bool = false

func _physics_process(delta: float) -> void:
	if get_tree().get_first_node_in_group("splitscreen").paused: # Doesn't work for singleplayer
		return
	
	# Set is_wall_climbing to true if Wallsliding and the run button is pressed
	is_wall_climbing = Input.is_action_pressed(run_modifier_action) and get_position_state() == STATE_ON_WALL
	
	var direction: float = get_horizontal_movement()
	
	# Don't do gravity when wallclibing
	if not is_wall_climbing: process_gravity(delta)
	process_jump(delta)
	
	update_flipped()
	
	process_walkrun(delta, direction)
	process_walljump(delta)
	process_wallclimb()
	
	animate_hip(direction)
	
	move_and_slide()

func process_wallclimb():
	if is_wall_climbing:
		var climbDirection = Input.get_axis(jump_action, crouch_action);
		velocity.y = climbDirection * 100;

func animate_hip(direction: float) -> void:
	if hitstun:
		sprite.animation = "hurt";
	elif is_on_wall() and not is_on_floor():
		sprite.animation = "wall-climb" if is_wall_climbing else "wall-cling";
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

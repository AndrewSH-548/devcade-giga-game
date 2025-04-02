extends "res://assets/scripts/player.gd"

@export var crouch_action: String = " "

var isWallClimbing: bool = false;
var isJumping: bool = false;

func _physics_process(delta: float) -> void:
	if (velocity.y >= 0): isJumping = false;
	isWallClimbing = false;
	
	if is_on_wall() and not is_on_floor() and Input.is_action_pressed(run_modifier_action) and !isJumping:
		isWallClimbing = true;
	
	# Add the gravity.
	if not is_on_floor() and not isWallClimbing:
		velocity.y += gravity * delta;
		velocity.y = clamp(velocity.y, -jump_height, fall_speed);

	# Handle jump.
	if Input.is_action_just_pressed(jump_action) and is_on_floor() and not isWallClimbing and not hitstun:
		velocity.y = -jump_height;
		isJumping = true;

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis(move_left_action, move_right_action)
	if not paused:
		flipCheck();
		animate(direction);
	# Move, and check whether the player in in hitstun
	if direction:
		# Push the player away from a wall when they jump off it.
		if Input.is_action_just_pressed(jump_action) and is_on_wall() and !is_on_floor() and not hitstun:
			velocity.x = -direction * wall_jump_height / 1.8;
			velocity.y = -wall_jump_height;
		elif !is_on_floor() and not hitstun:
			if abs(velocity.x) < air_speed:
				velocity.x += direction * air_accel;
			else:
				velocity.x = move_toward(velocity.x, direction*air_speed, air_accel);
		elif Input.is_action_pressed(run_modifier_action) and not hitstun:
			velocity.x = direction * run_speed;
		elif not hitstun:
			velocity.x = direction * walk_speed;
	else:
		velocity.x = move_toward(velocity.x, 0, 50); # use air_accel? 
	
	if isWallClimbing:
		var climbDirection = Input.get_axis(jump_action, crouch_action);
		velocity.y = climbDirection * 100;
	
	move_and_slide()

func animate(direction: float) -> void:
	if hitstun:
		sprite.animation = "hurt";
	elif is_on_wall() and not is_on_floor():
		sprite.animation = "wall-climb" if isWallClimbing else "wall-cling";
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

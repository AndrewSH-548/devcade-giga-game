extends CharacterBody2D

# Export stats
@export var walk_speed: int;
@export var run_speed: int;
@export var air_speed: int;
@export var air_accel: int;
@export var jump_height: int;
@export var wall_jump_height: int;
@export var fall_speed: int;
@export var gravity: int;
@export var weight: int;

@export var jump_action: String = " "
@export var move_left_action: String = " "
@export var move_right_action: String = " "
@export var run_modifier_action: String = " "

var acceleration: float = 0;
var hitstun: bool = false;

var sprite: AnimatedSprite2D;
var isFacingRight: bool = true;

func _ready() -> void:
	sprite = get_node("AnimatedSprite2D");
	sprite.play();

func _physics_process(delta: float) -> void:
	if $"../../../../".paused: # Doesn't work for singleplayer 
		return;
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta;
		velocity.y = clamp(velocity.y, -jump_height, fall_speed);

	# Handle jump.
	if Input.is_action_just_pressed(jump_action) and is_on_floor() and not hitstun:
		velocity.y = -jump_height;

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis(move_left_action, move_right_action)
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

	move_and_slide()

func animate(direction: float) -> void:
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

func flipCheck() -> void:
	if Input.is_action_just_pressed(move_left_action) and isFacingRight:
		isFacingRight = false;
	elif Input.is_action_just_pressed(move_right_action) and not isFacingRight:
		isFacingRight = true;

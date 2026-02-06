extends Player
class_name PlayerRickShawn

@export var magnet: PackedScene;

var is_throwing: bool = false;
var is_hanging: bool = false;
var magnet_ref: StaticBody2D;
var rope_distance: float;
var hanging_position: Vector2;

func _physics_process(delta: float) -> void:
	hanging_position = global_position + Vector2(28, -50)
	var header = get_tree().get_first_node_in_group("splitscreen")
	if header != null and header.paused:
		return
	
	var direction := get_horizontal_movement()
	
	# Hanging state is entirely separate from standard movement code, so none of it is processed.
	if (is_hanging): process_hanging(delta, direction);
	else:
		process_gravity(delta)
		process_jump(delta)
		process_wallcheck(delta)
		process_walljump(delta)
		process_walkrun(delta, direction)
		process_magnet_throw(delta)
		update_flipped()
	
	# Letting go of the input or landing deletes the magnet. 
	if (magnet_ref != null and (Input.is_action_just_released(run_modifier_action) or is_on_floor())):
		delete_magnet();
	animate_rick(direction)

	move_and_slide()
	
func animate_rick(direction: float) -> void:
	if hitstun:
		sprite.animation = "hurt"
	elif is_touching_wall() and not is_on_floor():
		sprite.animation = "wall-cling"
	elif is_throwing:
		sprite.animation = "throw"
	elif is_hanging:
		sprite.animation = "hang"
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

# Upon input, the magnet is spawned and thrown in the current direction of Rick. Requires being airborne.
# A reference variable allows the magnet to be modified without having to search for it.
func process_magnet_throw(_delta: float) -> void: 
	if (not is_throwing and Input.is_action_just_pressed(run_modifier_action) and not is_on_floor() and not is_touching_wall()):
		is_throwing = true;
		var magnet_object: StaticBody2D = magnet.instantiate();
		magnet_object.global_position = global_position;
		magnet_object.is_facing_right = is_facing_right;
		magnet_ref = magnet_object;
		add_sibling(magnet_object)

func process_hanging(delta: float, direction: float) -> void:
	# Function-specific gravity statement
	velocity.y += gravity * delta;
	
	var to_magnet: Vector2 = magnet_ref.global_position - global_position;
	var current_distance: float = to_magnet.length();
	
	# Allow the player to move while hanging.
	if (direction != 0):
		var swing_force: float = direction * delta * 600;
		velocity.x += swing_force;
	
	# Tension ensures the player hangs off the magnet at the distance it starts with.
	if (current_distance > rope_distance):
		var overflow_distance: float = current_distance - rope_distance;
		var tension: Vector2 = to_magnet.normalized() * overflow_distance * 400;
		velocity += tension * delta;
	
	# Walljumping deletes the magnet.
	if (Input.is_action_just_pressed(jump_action) && is_on_wall()):
		do_walljump();
		delete_magnet();

func delete_magnet() -> void:
	magnet_ref.queue_free(); 
	magnet_ref = null;
	is_throwing = false;
	is_hanging = false;

func setup_keybinds(player_number: int) -> void:
	var player_input: String = "p" + str(player_number) + "_"
	jump_action = player_input + "jump"
	move_left_action = player_input + "left"
	run_modifier_action = player_input + "run"
	move_right_action = player_input + "right"

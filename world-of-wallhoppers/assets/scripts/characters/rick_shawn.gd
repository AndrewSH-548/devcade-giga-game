extends Player
class_name PlayerRickShawn

@export var magnet: PackedScene;
@export var pull_speed: float = 1024.0
@export var boost_upward_strength: float = 256.0

@onready var facing_flipper: Node2D = $Flipper
@onready var foot_position_marker: Marker2D = $FootPositionMarker
@onready var magnet_launch_position: Marker2D = $Flipper/MagnetLaunchPosition

enum {
	PLATFORMING,
	THROWING,
	PULLING,
}

var magnet_ref: CharacterBody2D
var rope_distance: float
var hanging_position: Vector2
var state: int = PLATFORMING

func _ready() -> void:
	foot_offset = foot_position_marker.global_position - global_position
	super._ready()

func _physics_process(delta: float) -> void:
	hanging_position = global_position + Vector2(28 * (1 if is_facing_right else -1), -50) 
	var header = get_tree().get_first_node_in_group("LevelHeader")
	if header != null and header.paused:
		return
	
	var modified_delta: float = get_modified_delta(delta)
	
	if halt_physics:
		if state == THROWING or state == PULLING:
			enter_platform_state()
		return
	
	# Flip the flipper based on the player's facing direction
	# This is used to position the throw point for the magnet correctly
	if is_facing_right:
		facing_flipper.scale.x = 1.0
	else:
		facing_flipper.scale.x = -1.0
	
	var direction := get_horizontal_movement()
	
	match state:
		PLATFORMING:
			process_gravity(modified_delta)
			process_jump(modified_delta)
			process_wallcheck(modified_delta)
			process_walljump(modified_delta)
			process_walkrun(modified_delta, direction)
			if get_position_state() != STATE_HITSTUN:
				process_magnet_throw(modified_delta)
			update_flipped()
		THROWING:
			process_gravity(modified_delta)
		PULLING:
			process_pulling(modified_delta)
			var collision: KinematicCollision2D = move_and_collide(velocity * modified_delta)
			# If Rick collided with a wall, or he was hit...
			if collision != null or get_position_state() == STATE_HITSTUN or Input.is_action_just_pressed(jump_action):
				enter_platform_state()
	
	animate_rick(direction)
	if state in [PLATFORMING, THROWING]:
		move(delta, modified_delta)

# Upon input, the magnet is spawned and thrown in the current direction of Rick. Requires being airborne.
# A reference variable allows the magnet to be modified without having to search for it.
func process_magnet_throw(_delta: float) -> void: 
	if Input.is_action_just_pressed(run_modifier_action) and not is_touching_wall():
		enter_throw_state()

func enter_throw_state() -> void:
	state = THROWING
	var magnet_object: CharacterBody2D = magnet.instantiate()
	magnet_object.global_position = magnet_launch_position.global_position
	magnet_object.is_facing_right = is_facing_right
	magnet_ref = magnet_object
	add_sibling(magnet_object)

func enter_pull_state() -> void:
	state = PULLING

func enter_platform_state() -> void:
	if magnet_ref != null:
		magnet_ref.queue_free()
		magnet_ref = null
	state = PLATFORMING
	if Input.is_action_just_pressed(jump_action):
		velocity.y = -boost_upward_strength

func process_pulling(_delta: float) -> void:
	velocity.y = 0
	velocity.x = facing * pull_speed

func on_passed_through_hollow(entered: Hollow, exited: Hollow) -> void:
	if magnet_ref != null:
		magnet_ref.rick_passed_through_hollow(entered, exited)

func animate_rick(direction: float) -> void:
	if hitstun:
		sprite.animation = "hurt"
	elif is_touching_wall() and not is_on_floor():
		sprite.animation = "wall-cling"
	elif state == THROWING:
		sprite.animation = "throw"
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
	move_left_action = player_input + "left"
	run_modifier_action = player_input + "run"
	move_right_action = player_input + "right"

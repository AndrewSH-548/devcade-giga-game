extends Player

@onready var normal_collision: CollisionShape2D = $NormalCollision
@onready var roll_collision: CollisionShape2D = $RollCollision

var kick_action: StringName

func _physics_process(delta: float) -> void:
	var header = get_tree().get_first_node_in_group("splitscreen")
	if header != null and header.paused:
		return
		
	var direction: float = get_horizontal_movement()
	
	process_walkrun(delta, direction)
	process_gravity(delta)
	update_flipped()
	animate_flare()
	
	move_and_slide()

func animate_flare():
	sprite.flip_h = !isFacingRight

func setup_keybinds(player_number: int) -> void:
	var player_input: String = "p" + str(player_number) + "_"
	jump_action = player_input + "jump"
	move_left_action = player_input + "left"
	run_modifier_action = player_input + "run"
	move_right_action = player_input + "right"
	kick_action = player_input + "run"

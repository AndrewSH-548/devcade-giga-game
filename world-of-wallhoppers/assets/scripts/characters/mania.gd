extends Player

const PHASE_TIME: float = 2.0
const PHASE_COOLDOWN: float = 5.0
const PHASE_MOVEMENT_MODIFIER: float = 1.3
const PHASE_JUMP_MODIFIER: float = 1.1

@onready var animations: AnimatedSprite2D = $Animations
@onready var phase_timer: Timer = make_timer(PHASE_TIME)
@onready var phase_cooldown: Timer = make_timer(PHASE_COOLDOWN)

func _ready() -> void:
	phase_timer.timeout.connect(end_phase)
	phase_cooldown.timeout.connect(end_cooldown)

func _physics_process(delta: float) -> void:
	if should_skip_physics():
		return
	
	var direction: float = get_horizontal_movement()
	
	process_gravity(delta)
	process_jump(delta)
	process_wallcheck(delta)
	process_walljump(delta)
	process_walkrun(delta, direction, get_movement_modifier())
	process_phase()
	
	update_flipped()
	
	move()
	
	animations.flip_h = !is_facing_right;

# OVERRIDES:
func do_hitstun(body: Node) -> void:
	if is_phasing():
		print("Skip Hitstun")
		return
	print("Do Hitstun")
	super.do_hitstun(body)

func do_walljump() -> void:
	velocity.x = get_pushoff_wall_direction() * wall_pushoff_strength 
	velocity.y = -wall_jump_height * get_jump_modifier()
	wall_jump_coyote_timer.stop()
	wall_jump_buffer_timer.stop()

func do_jump() -> void:
	velocity.y = -jump_height * get_jump_modifier()

# END OF OVERRIDES

func can_phase() -> bool:
	return not is_phase_cooldown() and not is_phasing()

func is_phasing() -> bool:
	return not phase_timer.is_stopped()

func is_phase_cooldown() -> bool:
	return not phase_cooldown.is_stopped()

func process_phase() -> void:
	if Input.is_action_just_pressed(run_modifier_action) and can_phase():
		start_phase()

func start_phase() -> void:
	phase_timer.start()
	modulate = Color.AQUA
	modulate.a = 0.6

func end_phase() -> void:
	phase_cooldown.start()
	modulate = Color.RED
	modulate.a = 1.0

func end_cooldown() -> void:
	modulate = Color.WHITE

func get_jump_modifier() -> float:
	return PHASE_JUMP_MODIFIER if is_phasing() else 1.0

func get_movement_modifier() -> float:
	return PHASE_MOVEMENT_MODIFIER if is_phasing() else 1.0

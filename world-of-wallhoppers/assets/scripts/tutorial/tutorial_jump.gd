extends TutorialPart

@onready var hip: AnimatedSprite2D = $Hip
@onready var player_hip: CharacterBody2D = $"../PlayerHip"
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var jump_timer: Timer = $JumpTimer
@onready var tutorial: Node2D = $".."
@onready var checkmark_2: Sprite2D = $Checkmark
@onready var button: AnimatedSprite2D = $Button

@export var progress_color: Gradient

var position_y: float
var jump_strength: float = 370.0
var gravity: float = 1280.0
var velocity: float = 0.0
var required_jumps: int = 3
var jumps: int = 0
var on_floor_last_frame: bool = false

func _ready() -> void:
	checkmark_2.visible = false
	position_y = hip.global_position.y
	var box: StyleBoxFlat = progress_bar.get_theme_stylebox("fill")
	box = box.duplicate()
	box.bg_color = progress_color.sample(0.0)
	progress_bar.add_theme_stylebox_override("fill", box)

func update(delta: float) -> void:
	if is_finished:
		return
	velocity += gravity * delta
	
	if hip.global_position.y >= position_y and velocity > 0.0:
		velocity = 0.0
		hip.global_position.y = position_y
	
	if velocity == 0.0:
		hip.play("Walk")
		hip.pause()
	elif velocity > 0.0:
		hip.play("Fall")
	else:
		hip.play("Jump")
	
	hip.global_position.y += velocity * delta
	
	if Input.is_action_just_pressed("p1_jump"):
		if on_floor_last_frame:
			jumps += 1
	
	progress_bar.value = (float(jumps) / float(required_jumps)) * 100.0
	var box: StyleBoxFlat = progress_bar.get_theme_stylebox("fill")
	box.bg_color = progress_color.sample(progress_bar.value / 100.0)
	progress_bar.add_theme_stylebox_override("fill", box)
	
	on_floor_last_frame = player_hip.test_move(player_hip.transform, Vector2(0.0, 32.9))
	if jumps >= required_jumps:
		is_finished = true
		jump_timer.stop()
		tutorial.confetti()
		checkmark_2.visible = true
		finished.emit()
		for child in get_children():
			if child.name != "Checkmark" and child is CanvasItem:
				child.modulate = Color(0.265, 0.265, 0.265, 1.0)

func jump():
	if not updating:
		return
	button.play("Pressed")
	velocity = -jump_strength
	await get_tree().create_timer(0.5).timeout
	button.play("Unpressed")

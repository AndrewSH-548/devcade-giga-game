extends TutorialPart

@onready var button: AnimatedSprite2D = $Button
@onready var left: Marker2D = $Left
@onready var right: Marker2D = $Right
@onready var hip: AnimatedSprite2D = $Hip
@onready var player_hip: CharacterBody2D = $"../PlayerHip"
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var checkmark: Sprite2D = $Checkmark
@onready var tutorial: Node2D = $".."

@export var progress_color: Gradient

var pressed: bool = false
var hip_walk_speed: float = 128.0
var hip_run_speed: float = 256.0
var hip_direction: int = 1

var run_time: float = 1.0
var time_ran: float = 0.0

func _ready() -> void:
	checkmark.visible = false
	var box: StyleBoxFlat = progress_bar.get_theme_stylebox("fill")
	box = box.duplicate()
	box.bg_color = progress_color.sample(0.0)
	progress_bar.add_theme_stylebox_override("fill", box)

func update(delta: float) -> void:
	if is_finished or not updating:
		return
	if hip.global_position.x < left.global_position.x:
		hip_direction = +1
		hip.flip_h = true
	if hip.global_position.x > right.global_position.x:
		hip_direction = -1
		hip.flip_h = false
	hip.global_position.x += hip_direction * delta * (hip_run_speed if pressed else hip_walk_speed)
	
	if Input.is_action_pressed("p1_run"):
		if player_hip.is_on_floor() and (Input.is_action_pressed("p1_left") or Input.is_action_pressed("p1_right")):
			time_ran += delta
	
	progress_bar.value = (time_ran / run_time) * 100.0
	
	var box: StyleBoxFlat = progress_bar.get_theme_stylebox("fill")
	box.bg_color = progress_color.sample(progress_bar.value / 100.0)
	progress_bar.add_theme_stylebox_override("fill", box)
	
	if progress_bar.value == 100.0:
		is_finished = true
		checkmark.visible = true
		for child in get_children():
			if child.name != "Checkmark" and child is CanvasItem:
				child.modulate = Color(0.265, 0.265, 0.265, 1.0)
		hip.pause()
		tutorial.confetti()
		finished.emit()

func toggle_button() -> void:
	if not updating: return
	pressed = not pressed
	if pressed:
		button.play("Pressed")
		hip.speed_scale = 2.0
	else:
		button.play("Unpressed")
		hip.speed_scale = 1.0

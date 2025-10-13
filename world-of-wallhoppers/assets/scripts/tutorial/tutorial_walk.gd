extends TutorialPart

@onready var hip: AnimatedSprite2D = $Hip
@onready var joystick: AnimatedSprite2D = $Joystick
@onready var change_timer: Timer = $ChangeTimer
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var tutorial: Node2D = $".."
@onready var checkmark: Sprite2D = $Checkmark

@export var progress_color: Gradient

enum {
	CENTER,
	LEFT,
	RIGHT,
}

var states: Array[int] = [
	CENTER,
	LEFT,
	CENTER,
	RIGHT,
]

var state: int = 0
var hip_movement: float = 0.0
var hip_speed: float = 128.0
var initlal: float

var walk_time: float = 3.0
var time_walked: float = 0.0

func _ready() -> void:
	checkmark.visible = false
	initlal = hip.position.x
	var box: StyleBoxFlat = progress_bar.get_theme_stylebox("fill")
	box = box.duplicate()
	box.bg_color = progress_color.sample(0.0)
	progress_bar.add_theme_stylebox_override("fill", box)

func change() -> void:
	if is_finished or not updating:
		change_timer.stop()
		return
	state = wrapi(state + 1, 0, states.size())
	match states[state]:
		CENTER:
			hip.stop()
			joystick.play("Center")
			hip_movement = 0.0
			change_timer.start(0.5)
		LEFT:
			hip.play()
			joystick.play("Push")
			joystick.flip_h = false
			hip.flip_h = false
			hip_movement = -hip_speed
			change_timer.start(1.0)
			hip.position.x = initlal
		RIGHT:
			hip.play()
			joystick.play("Push")
			joystick.flip_h = true
			hip.flip_h = true
			hip_movement = hip_speed
			change_timer.start(1.0)

func update(delta: float):
	if is_finished: return
	hip.position.x += hip_movement * delta
	if Input.is_action_pressed("p1_left") or Input.is_action_pressed("p1_right"):
		time_walked += delta
	progress_bar.value = clamp(time_walked / walk_time, 0.0, 1.0) * 100.0
	var box: StyleBoxFlat = progress_bar.get_theme_stylebox("fill")
	box.bg_color = progress_color.sample(progress_bar.value / 100.0)
	progress_bar.add_theme_stylebox_override("fill", box)
	if progress_bar.value == 100.0:
		finish()

func finish():
	if is_finished: return
	modulate = Color(0.265, 0.265, 0.265, 1.0)
	tutorial.confetti()
	hip.pause()
	joystick.pause()
	checkmark.visible = true
	finished.emit()
	is_finished = true

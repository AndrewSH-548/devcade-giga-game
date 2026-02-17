extends Node2D

@onready var tutorial: Node2D = $"."
@onready var camera: Camera2D = $Camera
@onready var player: Player = $PlayerHip

@onready var camera_scroll_bottom: Marker2D = $CameraScrollBottom
@onready var camera_scroll_top: Marker2D = $CameraScrollTop

@onready var tutorial_walk: Node2D = $TutorialWalk
@onready var tutorial_jump: Node2D = $TutorialJump
@onready var tutorial_run: Node2D = $TutorialRun
@onready var tutorial_walljump: Node2D = $TutorialWalljump

@onready var confetti_left: Confetti = $Confetti/ConfettiLeft
@onready var confetti_right: Confetti = $Confetti/ConfettiRight
@onready var complete: Label = $Complete
@onready var tutorial_position: Marker2D = $TutorialPosition
@onready var complete_bar: ProgressBar = $Complete/CompleteBar

@onready var tutorials: Array[Node2D] = [
	tutorial_walk,
	tutorial_jump,
	tutorial_run,
	tutorial_walljump,
]

@export var progress_color: Gradient

var tutorial_index: int = 0
var finished_tutorial: bool = false
var exit_fill_speed: float = 0.5
var exit_fill: float = 0.0
var paused: bool = false;

func _ready() -> void:
	player.setup_keybinds(1)
	
	while tutorial_index < tutorials.size():
		
		tutorials[tutorial_index].visible = true
		tutorials[tutorial_index].updating = true
		
		await tutorials[tutorial_index].finished
		
		tutorials[tutorial_index].updating = false
		tutorials[tutorial_index].fade()
		
		await get_tree().create_timer(0.5).timeout
		
		tutorials[tutorial_index].visible = false
		tutorial_index += 1
	
	complete.visible = true
	finished_tutorial = true

func _physics_process(delta: float) -> void:
	tutorial_walk.global_position.y = lerpf(tutorial_walk.global_position.y, tutorial_position.global_position.y, 0.26)
	if tutorial_index < tutorials.size():
		tutorials[tutorial_index].update(delta)
	
	
	if not finished_tutorial: return
	
	if Input.is_action_pressed("p1_run"):
		exit_fill += exit_fill_speed * delta
	else:
		exit_fill -= exit_fill_speed * delta
	exit_fill = clampf(exit_fill, 0.0, 1.0)
	complete_bar.value = exit_fill
	
	var box: StyleBoxFlat = complete_bar.get_theme_stylebox("fill")
	box.bg_color = progress_color.sample(complete_bar.value)
	complete_bar.add_theme_stylebox_override("fill", box)
	
	if exit_fill == 1.0:
		var start_screen: Control = load("res://scenes/start_screen.tscn").instantiate()
		get_tree().root.add_child(start_screen)
		queue_free()
		

func confetti():
	confetti_left.burst()
	confetti_right.burst()

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

@onready var tutorials: Array[Node2D] = [
	tutorial_walk,
	tutorial_jump,
	tutorial_run,
	tutorial_walljump,
]

var tutorial_index: int = 0

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
	await get_tree().create_timer(1.0).timeout
	
	var start_screen: Control = load("res://scenes/start_screen.tscn").instantiate()
	get_tree().root.add_child(start_screen)
	queue_free()

func _physics_process(delta: float) -> void:
	tutorial_walk.global_position.y = lerpf(tutorial_walk.global_position.y, tutorial_position.global_position.y, 0.26)
	if tutorial_index < tutorials.size():
		tutorials[tutorial_index].update(delta)

func confetti():
	confetti_left.burst()
	confetti_right.burst()

extends TutorialPart

@onready var hip: AnimatedSprite2D = $Hip
@onready var wall: Marker2D = $Wall
@warning_ignore("shadowed_global_identifier")
@onready var floor: Marker2D = $Floor
@onready var button: AnimatedSprite2D = $Button
@onready var player_hip: CharacterBody2D = $"../PlayerHip"
@onready var tutorial: Node2D = $".."
@onready var checkmark: Sprite2D = $Checkmark
@onready var progress_bar: ProgressBar = $ProgressBar

@export var progress_color: Gradient

var velocity: Vector2

var acceleration: float = 720.0 * 3
var walk_speed: float = 256.0
var jump_strength: float = 236.0
var pushoff_strength: float = 400.0
var gravity: float = 550.0

var required_jumps: int = 3
var jumps: int = 0

func update(delta: float):
	if is_finished: return
	if not updating: return
	velocity.x = move_toward(velocity.x, -walk_speed, delta * acceleration)
	velocity.y += gravity * delta
	
	if on_wall():
		hip.play("Wall")
	else:
		if on_floor():
			hip.play("Walk")
		else:
			if velocity.y < 0:
				hip.play("Jump")
			else:
				hip.play("Fall")
	
	hip.global_position += velocity * delta
	snap()
	
	if (not player_hip.is_on_floor() and
		(player_hip.test_move(player_hip.transform, Vector2(8, 0)) or
		player_hip.test_move(player_hip.transform, Vector2(-8, 0)))):
		if Input.is_action_just_pressed("p1_jump"):
			jumps += 1
	
	progress_bar.value = (jumps / float(required_jumps)) * 100.0
	
	if jumps >= required_jumps:
		is_finished = true
		for child in get_children():
			if child.name != "Checkmark" and child is CanvasItem:
				child.modulate = Color(0.265, 0.265, 0.265, 1.0)
		tutorial.confetti()
		hip.pause()
		button.pause()
		checkmark.visible = true
		finished.emit()
		is_finished = true

func snap() -> void:
	hip.global_position.x = clamp(hip.global_position.x, wall.global_position.x, INF)
	hip.global_position.y = clamp(hip.global_position.y, -INF, floor.global_position.y)

func on_floor():
	return hip.global_position.y == floor.global_position.y

func on_wall() -> bool:
	return hip.global_position.x == wall.global_position.x

func jump() -> void:
	if is_finished or not updating: return
	if on_floor():
		velocity.y = -jump_strength
		button.play()
		await get_tree().create_timer(0.5).timeout
		if is_finished or not updating: return
		button.play()
		pushoff()
		await get_tree().create_timer(0.5).timeout
		if is_finished or not updating: return
		button.play()
		pushoff()
		acceleration /= 5.0
		await get_tree().create_timer(0.5).timeout
		acceleration *= 5.0

func pushoff() -> void:
	velocity.x = pushoff_strength
	velocity.y = -jump_strength

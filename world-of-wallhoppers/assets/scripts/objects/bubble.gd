class_name Bubble
extends CharacterBody2D

@onready var trigger: Area2D = $Trigger
@export var launch_height: float = 128

const BUBBLE = preload("res://scenes/objects/bubble/bubble.tscn")

enum {
	FLOATING,
	FLYING,
}

var state: int = FLOATING
var captured_player: Player = null
var acceleration: float = 512

var setup: bool = false

func _ready() -> void:
	trigger.body_entered.connect(on_body_entered)
	await get_tree().create_timer(0.2).timeout
	setup = true

func on_body_entered(body: Node2D) -> void:
	if not setup:
		return
	if state != FLOATING:
		return
	if body is not Player:
		return
	var player: Player = body as Player
	
	if player.halt_physics == true:
		return
	
	var new_bubble: Bubble = BUBBLE.instantiate()
	get_parent().add_child(new_bubble)
	new_bubble.global_position = global_position
	new_bubble.acceleration = acceleration
	new_bubble.launch_height = launch_height
	
	setup_player(player)
	captured_player = player
	state = FLYING

func _physics_process(delta: float) -> void:
	if state == FLOATING:
		return
	velocity.y -= acceleration * delta * delta
	var collision: KinematicCollision2D = move_and_collide(velocity)
	captured_player.global_position = global_position
	if collision != null:
		pop()

func setup_player(player: Player) -> void:
	player.halt_physics = true
	if player is PlayerScoria:
		(player as PlayerScoria).move_state = PlayerScoria.MoveState.NORMAL

func pop() -> void:
	if captured_player != null:
		captured_player.halt_physics = false
		captured_player.velocity.y = Phys.force_to_launch_to_height(captured_player, launch_height, true)
	queue_free()

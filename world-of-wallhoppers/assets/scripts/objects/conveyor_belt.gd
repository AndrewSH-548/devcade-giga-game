@tool
extends Node2D

@export var flipped: bool = false
@onready var push_area: Area2D = $PushArea
@onready var side: Panel = $Sprite/Side
@onready var push_shape: CollisionShape2D = $PushArea/PushShape

var acceleration : float = 5200.0
var max_speed: float = 512.0
var walk_modifier: float = 1.5

func _ready() -> void:
	editor_update()

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		editor_update()
		return
	
	var direction: Vector2 = Vector2.from_angle(snappedf(rotation, PI / 2.0))
	
	if direction == Vector2.ZERO:
		return
	
	var x_direction: float = sign(direction.x)
	var true_walk_modifier: float = walk_modifier * x_direction
	if x_direction == 0.0:
		true_walk_modifier = 1.0
	
	for body in push_area.get_overlapping_bodies():
		if body is CharacterBody2D:
			print((direction * max_speed).length())
			body.velocity = body.velocity.move_toward(direction * max_speed, acceleration * delta)
			if body is Player:
				(body as Player).disable_decceleration_timed(0.5)
				#(body as Player).disable_walk_input_timed(0.1)
				(body as Player).walk_speed_frame_modifier_directional = true_walk_modifier
		elif body is RigidBody2D:
			body.linear_velocity = body.linear_velocity.move_toward(direction * max_speed, acceleration * delta)

func editor_update() -> void:
	side.scale.y = 1.0 if not flipped else -1.0
	if flipped:
		push_shape.position.y = 5
	else:
		push_shape.position.y = -2

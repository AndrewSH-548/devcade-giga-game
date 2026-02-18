@tool
extends CharacterBody2D

@export var desination: Vector2 = Vector2(-64, 0)
@export_range(0.0, 2.0, 0.01) var initial_progress: float 
var towards_desination: bool = true
@onready var sprite: AnimatedSprite2D = $Sprite

var speed: float = 128.0
var start_global: Vector2
var end_global: Vector2

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	start_global = global_position
	end_global = global_position + desination
	if(initial_progress <= 1.0):
		global_position = start_global + (end_global - start_global) * initial_progress
	else:
		global_position = end_global - (end_global - start_global) * (initial_progress - 1)

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		queue_redraw()
		return
	
	if towards_desination and global_position == end_global:
		towards_desination = false
		sprite.flip_h = true
	if not towards_desination and global_position == start_global:
		towards_desination = true
		sprite.flip_h = false
	
	var velocity_position: Vector2 = global_position
	if towards_desination:
		velocity_position = velocity_position.move_toward(end_global, speed * delta)
	else:
		velocity_position = velocity_position.move_toward(start_global, speed * delta)
	velocity = velocity_position - global_position
	velocity /= delta
	move_and_slide()

func _draw() -> void:
	if not Engine.is_editor_hint():
		return
	draw_line(desination - Vector2(30, 0), desination + Vector2(30, 0), Color.DEEP_SKY_BLUE, 2)
	draw_line(Vector2.ZERO, desination, Color.RED, 1)
	if initial_progress <= 1.0:
		draw_line(Vector2.ZERO, desination * initial_progress, Color.GREEN, 2)
	else:
		draw_line(desination, desination - desination * (initial_progress - 1), Color.GREEN, 2)
	draw_circle(desination, 8, Color.RED, false, 2)

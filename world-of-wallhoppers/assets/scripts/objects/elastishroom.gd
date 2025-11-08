@tool
extends Node2D
class_name ObjectElastishroom

@onready var sprite: AnimatedSprite2D = $Sprite

@export_enum("Right", "Left") var facing: int = 1:
	set(new):
		facing = new
		if sprite: update_sprite()

func _ready() -> void:
	update_sprite()

func update_sprite() -> void:
	sprite.flip_h = facing == 0

func get_facing_sign() -> int:
	return -1 if facing == 1 else 1

func _physics_process(_delta: float) -> void:
	if not sprite.is_playing() and sprite.animation == &"Bounce":
		sprite.play("Idle")

func on_body_entered(body: Node2D) -> void:
	if body is Player:
		if body is PlayerScoria:
			if body.move_state == PlayerScoria.MoveState.ROLL:
				body.isFacingRight = facing == 0
				body.spark_progress += body.rebound_spark_amount
				body.spark_animation.play()
		body.velocity.y = -720
		body.velocity.x = 500 * get_facing_sign()
		body.move_and_collide(Vector2(0, -4))
		body.disable_walk_input_timed(0.1)
		body.disable_decceleration_timed(0.5)
		sprite.play("Bounce")

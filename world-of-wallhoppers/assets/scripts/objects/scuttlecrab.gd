@tool
extends AnimatableBody2D
class_name ObjectSucctlecrab

@export_enum("Right Wall", "Left Wall") var flipped: int = 1:
	set(new):
		flipped = new
		update_flipped()

enum {
	SLEEPING,
	WAITING,
	MOVING,
	RETURN,
}
var state: int = SLEEPING

@onready var sprite: AnimatedSprite2D = $Sprite

var velocity: Vector2 = Vector2.ZERO
var acceleration: float = 1024.0
var max_speed: float = 2560.0
var return_speed: float = 256
var wait_timer: Timer = Timer.new()
@onready var player_detector: Area2D = $PlayerDetector

func update_flipped():
	if sprite != null:
		sprite.flip_h = flipped == 0

func _ready() -> void:
	update_flipped()
	if Engine.is_editor_hint(): return
	add_child(wait_timer)
	wait_timer.one_shot = true
	wait_timer.timeout.connect(func(): state = RETURN)

func on_body_on_top(body: Node2D) -> void:
	if state == SLEEPING and body is Player:
		velocity = Vector2.ZERO
		state = MOVING
		sprite.play("Scuttle")

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint(): return
	Engine.print_error_messages = false
	match state:
		MOVING:
			velocity.y = move_toward(velocity.y, -max_speed, acceleration * delta)
			var last_velocity: float = velocity.y
			var collision: KinematicCollision2D = move_and_collide(velocity * delta)
			if collision != null:
				state = WAITING
				wait_timer.start(1.0)
				for body in player_detector.get_overlapping_bodies():
					if body is Player:
						body.velocity.y = -320 * abs(last_velocity / max_speed)
		RETURN:
			velocity.y = return_speed
			var collision: KinematicCollision2D = move_and_collide(velocity * delta)
			if collision != null:
				state = SLEEPING
				sprite.play("Sleep")

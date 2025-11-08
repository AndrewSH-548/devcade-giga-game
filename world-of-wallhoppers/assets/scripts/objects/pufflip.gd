@tool
extends Node2D
class_name ObstaclePufflip

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var collision: CollisionShape2D = $HitArea/Collision

const puff_color: Color = Color(0.965, 0.575, 0.66, 1.0)
const small_color: Color = Color(0.417, 0.868, 0.737, 1.0)

@export_enum("Puff", "Small") var initial_state: int = 1:
	set(new):
		initial_state = new
		if sprite != null:
			update_puff_start()

func update_puff_start():
	if initial_state == 0:
		sprite.animation = "Puff"
		modulate = puff_color
	else:
		sprite.animation = "Shrink"
		modulate = small_color
	sprite.frame = sprite.animation.length() - 1

func _ready() -> void:
	update_puff_start()
	sprite.rotation = randf() * TAU

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint(): return
	sprite.rotation += delta * 0.5
	var is_puffed: bool = sprite.animation == &"Puff" and sprite.frame == 1
	if collision.disabled and is_puffed:
		collision.disabled = false
	if not collision.disabled and not is_puffed:
		collision.disabled = true

func flip() -> void:
	if Engine.is_editor_hint(): return
	if sprite.animation == "Puff":
		sprite.play("Shrink")
	else:
		sprite.play("Puff")

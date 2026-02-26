extends RigidBody2D
class_name Bomb

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func explode():
	sprite.play("explosion")
	await get_tree().create_timer(0.6).timeout;
	queue_free()


func _on_player_collision(body: Node2D) -> void:
	if (!body is Player): return;
	explode()
	freeze = true
	gravity_scale = 0.0
	linear_velocity = Vector2.ZERO

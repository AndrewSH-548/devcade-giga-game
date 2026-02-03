extends RigidBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func explode():
	sprite.play("explosion")
	await get_tree().create_timer(0.6).timeout;
	queue_free();


func _on_player_collision(body: Node2D) -> void:
	if (!body is Player): return;
	explode();

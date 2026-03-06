extends Sprite2D

@export var rotation_velocity: float = 1.0

func _process(delta: float) -> void:
	rotation += rotation_velocity * delta

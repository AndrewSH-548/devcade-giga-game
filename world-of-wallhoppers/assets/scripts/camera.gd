extends Camera2D

@export var target:CharacterBody2D;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if target.position.y < 50:
		position = Vector2(position.x, target.position.y);

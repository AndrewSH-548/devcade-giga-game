extends Control
class_name CharacterSelectDialButton

@export var dial_position_angle: float

var selected: bool = false
var size_speed: float = 5.0

func _process(delta: float) -> void:
	if selected:
		scale = scale.move_toward(Vector2.ONE * 1.2, delta * size_speed)
	else:
		scale = scale.move_toward(Vector2.ONE, delta * size_speed)

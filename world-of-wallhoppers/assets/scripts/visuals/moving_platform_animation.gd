extends Sprite2D

func _process(delta: float) -> void:
	var time: float = Time.get_ticks_msec() / 1000.0
	var wobble_speed: float = time * 25
	offset = Vector2(sin(wobble_speed), cos(wobble_speed)) / 3.0

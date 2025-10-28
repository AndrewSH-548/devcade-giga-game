@tool
extends Marker2D

func _ready() -> void:
	if not Engine.is_editor_hint():
		queue_free()
	z_index = 100

func _draw() -> void:
	draw_line(Vector2(-1080/4.0, 0), Vector2(1080/4.0, 0), Color.RED, 5.0, false)
	draw_line(Vector2(0, 32), Vector2(0, -32), Color.RED, 5.0, false)

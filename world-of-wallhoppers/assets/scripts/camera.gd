extends Camera2D
class_name PlayerCamera

var target: CharacterBody2D
var scroll_bounds_top: float
var scroll_bounds_bottom: float

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var half_height: float = get_viewport_rect().size.y / 2.0
	
	global_position.y = target.global_position.y
	global_position.y = clampf(global_position.y, scroll_bounds_top + half_height, scroll_bounds_bottom - half_height)

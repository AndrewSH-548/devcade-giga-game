extends Camera2D
class_name PlayerCamera

var target: CharacterBody2D
var scroll_bounds_top: float
var scroll_bounds_bottom: float

var center: float
var freecam: bool = false
var freecam_speed: float = 1024.0


func setup() -> void:
	global_position.y = target.global_position.y
	clamp_to_level()
	reset_smoothing()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not Debug.values_freecam:
		process_normal()
	else:
		process_freecam(delta)

func process_normal() -> void:
	global_position.x = center
	global_position.y = target.global_position.y
	
	clamp_to_level()

func clamp_to_level() -> void:
	var half_height: float = get_viewport_rect().size.y / 2.0
	global_position.y = clampf(global_position.y, scroll_bounds_top + half_height, scroll_bounds_bottom - half_height)


func process_freecam(delta: float) -> void:
	global_position += delta * freecam_speed * Input.get_vector("p1_left", "p1_right", "p1_up", "p1_down")

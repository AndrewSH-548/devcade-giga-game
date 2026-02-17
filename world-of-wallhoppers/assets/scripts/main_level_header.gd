extends Node2D
class_name MainLevelHeader

var paused: bool = false;
var current_session_info: SessionInfo

func setup(_session_info: SessionInfo) -> void:
	# This should be overidden in child classses! (Singlescreen, Splitscreen)
	pass

func place_level(level: Node2D, parent_node: Node):
	assert(level is Level, "Level must be a \"Level\" node! Make sure the top node of the level has the \"Level\" Script!")
	level = level as Level
	level.global_position = Vector2(132.0, 297.0)
	parent_node.add_child(level)
	
	var camera_1: PlayerCamera = get_tree().get_first_node_in_group("Player1Camera")
	var camera_2: PlayerCamera = get_tree().get_first_node_in_group("Player2Camera")
	
	var top_level_bounds: float = level.get_node("ScrollStopTop").global_position.y
	var bottom_level_bounds: float = level.get_node("ScrollStopBottom").global_position.y
	
	camera_1.scroll_bounds_top = top_level_bounds
	camera_1.scroll_bounds_bottom = bottom_level_bounds
	camera_1.setup()
	
	if camera_2 != null:
		camera_2.scroll_bounds_top = top_level_bounds
		camera_2.scroll_bounds_bottom = bottom_level_bounds
		camera_2.setup()

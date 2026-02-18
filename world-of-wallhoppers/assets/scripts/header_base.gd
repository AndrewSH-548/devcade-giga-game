@abstract
extends Node2D
class_name LevelHeaderBase

var paused: bool = false;
var current_session_info: SessionInfo

@onready var pause_menu: Control = $PauseMenu

@abstract func header_scene() -> String
@abstract func setup(session_info: SessionInfo) -> void

func place_level(level: Node2D, parent_node: Node):
	assert(level is Level, "Level must be a \"Level\" node! Make sure the top node of the level has the \"Level\" Script!")
	assert(current_session_info != null, "SessionInfo is null! place_level() must be called from setup() in the Level Header!")
	level = level as Level
	level.global_position = Vector2(132.0, 297.0)
	parent_node.add_child(level)
	
	var camera_1: PlayerCamera = null
	var camera_2: PlayerCamera = null
	
	if not current_session_info.is_multiplayer:
		camera_1 = $ViewportContainerP1/SubViewport/Camera2D
	else:
		camera_1 = $HBoxContainer/ViewportContainerP1/SubViewport/CameraP1
		camera_2 = $HBoxContainer/ViewportContainerP2/SubViewport/CameraP2
	
	var top_level_bounds: float = level.get_node("ScrollStopTop").global_position.y
	var bottom_level_bounds: float = level.get_node("ScrollStopBottom").global_position.y
	
	camera_1.scroll_bounds_top = top_level_bounds
	camera_1.scroll_bounds_bottom = bottom_level_bounds
	camera_1.setup()
	
	if camera_2 != null:
		camera_2.scroll_bounds_top = top_level_bounds
		camera_2.scroll_bounds_bottom = bottom_level_bounds
		camera_2.setup()

func restart() -> void:
	var parent: Node = get_parent()
	parent.move_child(self, parent.get_child_count() - 1)
	add_new_header.call_deferred(get_tree().root, load(header_scene()), current_session_info)
	queue_free()

static func add_new_header(root: Node, header_packed_scene: PackedScene, session_info: SessionInfo) -> void:
	var new_header: LevelHeaderBase = header_packed_scene.instantiate()
	root.add_child(new_header)
	TimeManager.reset_timer()
	new_header.get_parent().move_child(new_header, 0)
	new_header.setup(session_info)

extends Button

@onready var level_viewport: SubViewport = $ViewportContainer/LevelViewport
@onready var level_name: Label = $Margins/LevelName
@onready var shading: ColorRect = $Shading

const SHOWCASE_SPEED: float = 64.0

var is_setup: bool = false
var level: Node2D
var thumbnail_marker: Node
var thumbnail_destination: Node
var backgrounds_manager: Node2D
var going_towards_destination: bool = true

func setup(level_info: LevelInfo):
	var level_scene: PackedScene = level_info.scene
	level_name.text = level_info.name
	is_setup = true
	assert(level_info.scene != null, "LevelInfo cannot be loaded with no level scene!")
	# Instantiate level and add it so the SubViewport
	level = level_scene.instantiate()
	level.process_mode = Node.PROCESS_MODE_DISABLED
	level_viewport.add_child(level)
	# Get the backgrounds manager
	backgrounds_manager = get_child_in_group(level, "BackgroundsManager")
	if backgrounds_manager != null:
		backgrounds_manager.thumbnail_mode = true
		backgrounds_manager.process_mode = Node.PROCESS_MODE_ALWAYS
	# Get the thumbnail marker, and if there is none return
	thumbnail_marker = get_child_in_group(level, "ThumbnailMarker")
	if thumbnail_marker == null: return
	thumbnail_destination = get_child_in_group(level, "ThumbnailDestination")
	# Position the level so that is only shows what is inside the thumbnail marker
	level.position = -thumbnail_marker.position

func get_child_in_group(parent: Node, group: StringName) -> Node:
	for node in parent.get_tree().get_nodes_in_group(group):
		if parent.is_ancestor_of(node):
			return node
	return null

func _process(delta: float) -> void:
	shading.visible = not is_hovered() and not get_viewport().gui_get_focus_owner() == self
	if not is_hovered() and not get_viewport().gui_get_focus_owner() == self:
		level.global_position = -thumbnail_marker.global_position
		return
	if backgrounds_manager != null:
		backgrounds_manager.manual_set_camera_position(-level.global_position)
	
	if thumbnail_destination == null or thumbnail_marker == null or not is_setup: return
	
	if going_towards_destination:
		level.global_position = level.global_position.move_toward(-thumbnail_destination.global_position, SHOWCASE_SPEED * delta)
		if level.position == -thumbnail_destination.global_position: going_towards_destination = false
	else:
		level.global_position = level.global_position.move_toward(-thumbnail_marker.global_position, SHOWCASE_SPEED * delta)
		if level.global_position == -thumbnail_marker.global_position: going_towards_destination = true

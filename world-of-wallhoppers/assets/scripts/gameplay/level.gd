@tool
extends Node2D
class_name Level

@export_tool_button("Generate Missing Markers") var gen_missing = generate_missing_members
@export_tool_button("Generate Thumbnail Markers") var gen_thumbnail = generate_thumbnail_markers

@onready var player_spawn_1: Marker2D
@onready var player_spawn_2: Marker2D

@onready var level_center: Marker2D

const THUMBNAIL_DESTINATION = preload("res://scenes/editor/thumbnail_destination.tscn")
const THUMBNAIL_MARKER = preload("res://scenes/editor/thumbnail_marker.tscn")

func _ready() -> void:
	if Engine.is_editor_hint():
		setup_editor()
		return
	
	player_spawn_1 = $PlayerSpawn1
	player_spawn_2 = $PlayerSpawn2
	
	level_center = $LevelCenter
	
	assert(level_center != null, "Level does not have a \"Level Center\" Marker2D node as a direct child! This is required for every level")
	assert(player_spawn_1 != null, "Level could not find Player 1's Spawn!\nMake sure there is a Node2D named \"PlayerSpawn1\" which is a direct child of the level!")
	assert(player_spawn_1 != null, "Level could not find Player 2's Spawn!\nMake sure there is a Node2D named \"PlayerSpawn2\" which is a direct child of the level!")

# All code in this region pertains only to the editor tools
#region Editor Only

# Generate any required and missing memebers for the level
func generate_missing_members() -> void:
	if get_node_or_null("LevelCenter") == null: _editor_add_child(Marker2D.new(), "LevelCenter")
	if get_node_or_null("PlayerSpawn1") == null: _editor_add_child(Marker2D.new(), "PlayerSpawn1")
	if get_node_or_null("PlayerSpawn2") == null: _editor_add_child(Marker2D.new(), "PlayerSpawn2")
	if get_node_or_null("ScrollStopBottom") == null: _editor_add_child(Marker2D.new(), "ScrollStopBottom")
	if get_node_or_null("ScrollStopTop") == null: _editor_add_child(Marker2D.new(), "ScrollStopTop")
	EditorInterface.mark_scene_as_unsaved()

# Generate markers needed for level thumbnails
func generate_thumbnail_markers() -> void:
	_editor_add_child(THUMBNAIL_MARKER.instantiate(), "ThumbnailMarker")
	_editor_add_child(THUMBNAIL_DESTINATION.instantiate(), "ThumbnailDestination")
	EditorInterface.mark_scene_as_unsaved()

# Update warnings when any node postion or name changes in the children
func setup_editor() -> void:
	child_order_changed.connect(func(): update_configuration_warnings())
	get_tree().node_renamed.connect(func(_a): update_configuration_warnings())

# Add a node to the editor correctly
func _editor_add_child(node: Node, node_name: String) -> void:
	add_child(node)
	node.owner = get_tree().edited_scene_root
	node.name = node_name

# Generates warnings to ensure level is setup correctly
func _get_configuration_warnings():
	var warnings = []
	
	if get_node_or_null("LevelCenter") == null:
		warnings.append("Level needs a Marker2D child named \"LevelCenter\"")
	if get_node_or_null("PlayerSpawn1") == null:
		warnings.append("Level needs a Marker2D child named \"PlayerSpawn1\"")
	if get_node_or_null("PlayerSpawn2") == null:
		warnings.append("Level needs a Marker2D child named \"PlayerSpawn2\"")
	if get_node_or_null("ScrollStopBottom") == null:
		warnings.append("Level needs a Marker2D child named \"ScrollStopBottom\"")
	if get_node_or_null("ScrollStopTop") == null:
		warnings.append("Level needs a Marker2D child named \"ScrollStopTop\"")
	
	# Returning an empty array means "no warning".
	return warnings
#endregion

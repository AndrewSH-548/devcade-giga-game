extends Node2D

const PLAYER_1_VISIBILITY: int = 4 # Visibility Layer 3
const PLAYER_2_VISIBILITY: int = 8 # Visibility Layer 4

const SCROLL_SCALE_GLOBAL: float = 0.5

@export var scroll_scale_local: float = 1.0
@export var extra_background_holders: Array[Node]

var player_1_camera: Camera2D
var player_2_camera: Camera2D

# Used to differentiate the backgrounds
var player_1_backgrounds: Array[Parallax2D]
var player_2_backgrounds: Array[Parallax2D]

var level_header: LevelHeaderBase

## This node should be setup with all parallax layers as direct children.

func _ready() -> void:
	add_to_group("BackgroundsManager")
	level_header = get_tree().get_first_node_in_group("LevelHeader")
	
	if level_header != null:
		player_1_camera = level_header.camera_player_1
		if level_header.current_session_info.is_multiplayer:
			player_2_camera = level_header.camera_player_2
	
	for background in get_children():
		setup_background(background)
	for extra in extra_background_holders:
		for background in extra.get_children():
			setup_background(background, extra)

func setup_background(background: Node, parent: Node = self):
	if background is not Parallax2D: return
	player_1_backgrounds.append(background)
	# Make this layer only visible to player 1. This is required for parallax
	background.visibility_layer = PLAYER_1_VISIBILITY
	background.ignore_camera_scroll = true
	# Skip the rest if in singleplayer
	if player_2_camera == null: return
	# Duplicate each parallax node fully
	var secondary_background: Parallax2D = background.duplicate()
	parent.add_child(secondary_background)
	player_2_backgrounds.append(secondary_background)
	secondary_background.global_position = background.global_position
	# Make this layer only visible to player 2. This is required for parallax
	secondary_background.visibility_layer = PLAYER_2_VISIBILITY
	#secondary_background.follow_viewport = false
	secondary_background.ignore_camera_scroll = true

func manual_set_camera_position(camera_position: Vector2):
	for background in get_children():
		if background is not Parallax2D: continue
		background.screen_offset.y = camera_position.y

func _process(_delta: float) -> void:
	if level_header == null: return
	for background in player_1_backgrounds:
		if background.scroll_scale.y == 0.0:
			background.screen_offset.y = player_1_camera.get_screen_center_position().y
		else:
			background.screen_offset.y = player_1_camera.get_screen_center_position().y * SCROLL_SCALE_GLOBAL * scroll_scale_local
	for background in player_2_backgrounds:
		if background.scroll_scale.y == 0.0:
			background.screen_offset.y = player_2_camera.get_screen_center_position().y
		else:
			background.screen_offset.y = player_2_camera.get_screen_center_position().y * SCROLL_SCALE_GLOBAL * scroll_scale_local

extends Node2D

const PLAYER_1_VISIBILITY: int = 4 # Visibility Layer 3
const PLAYER_2_VISIBILITY: int = 8 # Visibility Layer 4

const SCROLL_SCALE_GLOBAL: float = 0.5

@export var scroll_scale_local: float = 1.0

var player_1_camera: Camera2D
var player_2_camera: Camera2D
var thumbnail_mode: bool = false

# Used to differentiate the backgrounds
var player_1_backgrounds: Array[Parallax2D]

## This node should be setup with all parallax layers as direct children.

func _ready() -> void:
	add_to_group("BackgroundsManager")
	player_1_camera = get_tree().get_first_node_in_group("Player1Camera")
	player_2_camera = get_tree().get_first_node_in_group("Player2Camera")
		
	for background in get_children():
		if background is not Parallax2D: continue 
		player_1_backgrounds.append(background)
		# Make this layer only visible to player 1. This is required for parallax
		background.visibility_layer = PLAYER_1_VISIBILITY
		background.ignore_camera_scroll = true
		# Skip the rest if in singleplayer
		if player_2_camera == null: continue
		# Duplicate each parallax node fully
		var secondary_background: Parallax2D = background.duplicate()
		add_child(secondary_background)
		secondary_background.global_position = background.global_position
		# Make this layer only visible to player 2. This is required for parallax
		secondary_background.visibility_layer = PLAYER_2_VISIBILITY
		#secondary_background.follow_viewport = false
		secondary_background.ignore_camera_scroll = true

func manual_set_camera_position(camera_position: Vector2):
	for background in get_children():
		background.screen_offset.y = camera_position.y

func _process(delta: float) -> void:
	if thumbnail_mode: return
	for background in get_children():
		if background is not Parallax2D: continue 
		if background in player_1_backgrounds:
			background.screen_offset.y = player_1_camera.get_screen_center_position().y * SCROLL_SCALE_GLOBAL * scroll_scale_local
		else: background.screen_offset.y = player_2_camera.get_screen_center_position().y * SCROLL_SCALE_GLOBAL * scroll_scale_local

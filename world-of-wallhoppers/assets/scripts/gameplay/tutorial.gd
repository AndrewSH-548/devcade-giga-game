extends Node2D

@onready var tutorial: Node2D = $"."
@onready var camera: PlayerCamera = $Camera
@onready var player: Player = $PlayerHip

@onready var camera_scroll_bottom: Marker2D = $CameraScrollBottom
@onready var camera_scroll_top: Marker2D = $CameraScrollTop

func _ready() -> void:
	camera.target = player
	
	camera.scroll_bounds_bottom = camera_scroll_bottom.global_position.y
	camera.scroll_bounds_top = camera_scroll_top.global_position.y
	
	player.setup_keybinds(1)

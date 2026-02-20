class_name LevelHeaderSingleplayer
extends LevelHeaderBase

@onready var singleplayer_timer_label: Label = $SingleplayerTimerLabel
@onready var singleplayer_timer: Timer = $SingleplayerTimer

const HEADER_SINGLEPLAYER_PATH: String = "res://scenes/header_singleplayer.tscn"

@onready var viewport_player_1: SubViewport = $ViewportContainerP1/SubViewport
@onready var camera_player_1: PlayerCamera = $ViewportContainerP1/SubViewport/Camera2D

func setup(session_info: SessionInfo) -> void:
	# Perform common setup
	var viewport: Node = $ViewportContainerP1/SubViewport
	var result: LevelHeaderBase.SetupResult = common_setup(session_info, viewport)
	# Get the first (and only) player in the result
	var player: Player = result.players[0]
	
	# Reset time trial timer
	TimeManager.reset_timer()
	
	# Setup camera targets
	camera_player_1.target = player
	
	# Set border colors
	$BorderLeft.color = session_info.level_info.border_color
	$BorderRight.color = session_info.level_info.border_color

func restart() -> void:
	singleplayer_timer.stop()
	super.restart()

func _on_singleplayer_timer_timeout() -> void:
	TimeManager.do_time_trial_time_tick(0.1);
	singleplayer_timer_label.text = "Time: " + str(TimeManager.current_time_trial_time);

func header_scene() -> String:
	return HEADER_SINGLEPLAYER_PATH

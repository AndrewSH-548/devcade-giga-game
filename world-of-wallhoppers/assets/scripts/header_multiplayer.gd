class_name LevelHeaderMultiplayer
extends LevelHeaderBase

const HEADER_MULTIPLAYER_PATH: String = "res://scenes/header_multiplayer.tscn"

@onready var viewport_player_1: SubViewport = $HBoxContainer/ViewportContainerP1/SubViewport
@onready var viewport_player_2: SubViewport = $HBoxContainer/ViewportContainerP2/SubViewport

@onready var camera_player_1: PlayerCamera = $HBoxContainer/ViewportContainerP1/SubViewport/CameraP1
@onready var camera_player_2: PlayerCamera = $HBoxContainer/ViewportContainerP2/SubViewport/CameraP2

func main_camera() -> PlayerCamera:
	return camera_player_1

func _ready() -> void:
	viewport_player_2.world_2d = viewport_player_1.world_2d

func setup(session_info: SessionInfo):
	# Perform common setup
	var result: LevelHeaderBase.SetupResult = common_setup(session_info, viewport_player_1)
	# Get the players from the result
	var players: Array[Player] = result.players
	
	# Setup camera targets
	camera_player_1.target = players[0]
	camera_player_2.target = players[1]
	
	camera_player_1.setup()
	camera_player_2.setup()

func header_scene() -> String:
	return HEADER_MULTIPLAYER_PATH

class_name LevelHeaderMultiplayer
extends LevelHeaderBase

const HEADER_MULTIPLAYER_PATH: String = "res://scenes/header_multiplayer.tscn"

@onready var viewport_player_1: SubViewport = $HBoxContainer/ViewportContainerP1/SubViewport
@onready var viewport_player_2: SubViewport = $HBoxContainer/ViewportContainerP2/SubViewport

@onready var camera_player_1: PlayerCamera = $HBoxContainer/ViewportContainerP1/SubViewport/CameraP1
@onready var camera_player_2: PlayerCamera = $HBoxContainer/ViewportContainerP2/SubViewport/CameraP2

func _ready() -> void:
	viewport_player_2.world_2d = viewport_player_1.world_2d
	Engine.time_scale = 1

func setup(session_info: SessionInfo):
	pause_menu.level_header = self
	pause_menu.button_restart.show()
	current_session_info = session_info
	
	var level: Node2D = session_info.level_info.scene.instantiate()
	place_level(level, viewport_player_1)
	level = level as Level
	
	var players: Array[Node2D]
	
	for character in session_info.characters:
		assert(character != null, "The Level Header was loaded with a null Character!\nThis likely means a Character Select Dial was setup incorrectly, or a non-setup Character was chosen!")
		var player: Player = character.scene.instantiate()
		
		players.append(player)
		viewport_player_1.add_child(player)
		
		var player_number: int = players.size()
		
		player.add_to_group("player" + str(player_number))
		player.setup_keybinds(player_number)
		
		assert(player_number <= 2, "There currently cannot be more than 2 players, but the players array is larger than 2!\nIf this has changed, please remove this asser() statement!")
	
	players[0].global_position = level.player_spawn_1.global_position
	players[1].global_position = level.player_spawn_2.global_position
	
	camera_player_1.target = players[0]
	camera_player_2.target = players[1]

func header_scene() -> String:
	return HEADER_MULTIPLAYER_PATH

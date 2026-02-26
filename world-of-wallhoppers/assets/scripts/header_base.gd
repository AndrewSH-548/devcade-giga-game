@abstract
extends Node2D
class_name LevelHeaderBase

var paused: bool = false;
var current_session_info: SessionInfo

@onready var pause_menu: Control = $PauseMenu

@abstract func header_scene() -> String
@abstract func setup(session_info: SessionInfo) -> void

# Used to return all needed information form the common setup function
class SetupResult:
	var players: Array[Player]
	var level: Level
	func _init(_players: Array[Player], _level: Level) -> void:
		players = _players
		_level = level

func common_setup(session_info: SessionInfo, main_viewport: SubViewport) -> SetupResult:
	assert(session_info != null, "SessionInfo cannot be null. Make sure that the SessionInfo object is being passed correctly to the LevelHeader!")
	# Reset time scale, in case it was slowed down when entering
	Engine.time_scale = 1
	
	# Store the current session info
	current_session_info = session_info
	# Setup the pause menu
	pause_menu.level_header = self
	# Hide the restart button in multiplayer
	pause_menu.button_restart.visible = not session_info.is_multiplayer
	
	# Setup and get the level
	var level: Level = common_setup_level(session_info, main_viewport)
	
	# Setup and get the players
	var players: Array[Player] = common_setup_players(session_info, main_viewport, level)
	
	# Create and return a SetupResult with the needed information
	return SetupResult.new(players, level)

func common_setup_level(session_info: SessionInfo, main_viewport: SubViewport) -> Level:
	var level: Node2D = session_info.level_info.scene.instantiate()
	place_level(level, main_viewport)
	return level

func common_setup_players(session_info: SessionInfo, main_viewport: SubViewport, level: Level) -> Array[Player]:
	var players: Array[Player]
	
	for character in session_info.characters:
		
		# Break if in singleplayer and a second character would be set up
		# Also prints an error message, as this should never happen, but
		# is not a fatal error
		if not session_info.is_multiplayer and players.size() + 1 >= 2:
			push_error("More than 1 character was loaded in singleplayer! Other players have been skipped, but this error should not be ignored!")
			break
		
		assert(character != null, "The Level Header was loaded with a null Character!\nThis likely means game_definitions.tres was setup incorrectly or game_definitions.tres is corrupted / messed up (which can sometimes happens with git merging)")
		var player: Player = character.scene.instantiate()
		
		players.append(player)
		main_viewport.add_child(player)
		
		var player_number: int = players.size()
		
		player.add_to_group("player" + str(player_number))
		player.setup_keybinds(player_number)
		
		assert(player_number <= 2, "There currently cannot be more than 2 players, but the players array is larger than 2!\nIf this has changed, please remove this assert() statement!")
		
		# Set the player's position to the correct player spawn
		match player_number:
			1: player.global_position = level.player_spawn_1.global_position
			2: player.global_position = level.player_spawn_2.global_position
	
	# Return the players
	return players

func place_level(level: Level, parent_node: Node):
	assert(level is Level, "Level must be a \"Level\" node! Make sure the top node of the level has the \"Level\" Script!")
	
	# Add the level to the level parent
	parent_node.add_child(level)
	
	# Get all the cameras in the level
	var cameras: Array[Camera2D] = []
	if not current_session_info.is_multiplayer:
		cameras = [ $ViewportContainerP1/SubViewport/Camera2D ]
	else:
		cameras = [
			$HBoxContainer/ViewportContainerP1/SubViewport/CameraP1,
			$HBoxContainer/ViewportContainerP2/SubViewport/CameraP2,
		]
	
	# Get the top and bottom bounds of the level
	var top_level_bounds: float = level.get_node("ScrollStopTop").global_position.y
	var bottom_level_bounds: float = level.get_node("ScrollStopBottom").global_position.y
	
	# Setup all cameras with the correct settings
	for camera in cameras:
		camera.global_position.x = level.level_center.global_position.x
		camera.scroll_bounds_top = top_level_bounds
		camera.scroll_bounds_bottom = bottom_level_bounds
		camera.setup()

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

# Gets either the singleplayer or multiplayer header, depending on session info's mode
static func get_level_header(session: SessionInfo) -> LevelHeaderBase:
	if session.is_multiplayer: return load("res://scenes/header_multiplayer.tscn").instantiate()
	else: return load("res://scenes/header_singleplayer.tscn").instantiate()

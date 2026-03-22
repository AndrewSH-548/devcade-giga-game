extends Node
class_name PluginLevelRunner

var config: DevStartupConfig
var session: SessionInfo

func _ready() -> void:
	config = ResourceLoader.load("user://dev/startup_config.tres")
	session = ResourceLoader.load("user://dev/startup_session.tres")
	
	if config.testroom:
		load_testroom.call_deferred()
		return
	
	load_level.call_deferred()

func load_testroom() -> void:
	# Get the testroom
	var testroom: Testroom = load("res://scenes/levels/testroom.tscn").instantiate()
	# Load it
	get_tree().root.add_child(testroom)
	# Pass the level header the session info
	testroom.setup_custom(session)
	# Delete this scene
	queue_free()

func load_level() -> void:
	# Get either the singleplayer or multiplayer header...
	var header: LevelHeaderBase = LevelHeaderBase.get_level_header(session)
	# Load it
	get_tree().root.add_child(header)
	# Pass the level header the session info
	header.setup(session)
	# Delete this scene
	queue_free()

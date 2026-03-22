@tool
extends EditorPlugin
class_name PluginMainLevelBar

var LEVEL_BAR: PackedScene
var bar: PluginLevelBar

const LEVEL_RUNNER = "res://addons/levelbar/level_runner.tscn"
const STARTUP_CONFIG: String = "user://dev/startup_config.tres"
const STARTUP_SESSION: String = "user://dev/startup_session.tres"

func _enable_plugin() -> void:
	# Add autoloads here.
	pass


func _disable_plugin() -> void:
	# Remove autoloads here.
	pass

# Initialization of the plugin goes here.
func _enter_tree() -> void:
	LEVEL_BAR = load("res://addons/levelbar/level_bar.tscn")
	bar = LEVEL_BAR.instantiate()
	
	add_control_to_container(CONTAINER_TOOLBAR, bar)
	bar.plugin = self
	
	var parent: Control = bar.get_parent_control()
	parent.move_child(bar, bar.get_index(true) - 2)
	
	var config: DevStartupConfig = ResourceLoader.load(STARTUP_CONFIG)
	var session_info: SessionInfo = ResourceLoader.load(STARTUP_SESSION)
	
	bar.set_player(session_info.characters[0].name, 1)
	if session_info.is_multiplayer:
		bar.set_player(session_info.characters[1].name, 2)
	
	if config.testroom:
		bar.set_level(&"Testroom")
	else:
		bar.set_level(session_info.level_info.name)

# Clean-up of the plugin goes here.
func _exit_tree() -> void:
	if bar == null:
		return
	remove_control_from_container(CONTAINER_TOOLBAR, bar)
	bar.queue_free()

func start_level(config: DevStartupConfig, session: SessionInfo) -> void:
	var directory: DirAccess = DirAccess.open("user://")
	directory.make_dir("dev")
	
	ResourceSaver.save(config, STARTUP_CONFIG)
	ResourceSaver.save(session, STARTUP_SESSION)
	
	EditorInterface.play_custom_scene(LEVEL_RUNNER)

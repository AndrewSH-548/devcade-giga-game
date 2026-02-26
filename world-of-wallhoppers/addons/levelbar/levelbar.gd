@tool
extends EditorPlugin
class_name PluginMainLevelBar

var LEVEL_BAR: PackedScene
var bar: PluginLevelBar

const LEVEL_RUNNER = "res://addons/levelbar/level_runner.tscn"

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

# Clean-up of the plugin goes here.
func _exit_tree() -> void:
	if bar == null:
		return
	remove_control_from_container(CONTAINER_TOOLBAR, bar)
	bar.queue_free()

func start_level(config: DevStartupConfig, session: SessionInfo) -> void:
	var directory: DirAccess = DirAccess.open("user://")
	directory.make_dir("dev")
	
	ResourceSaver.save(config, "user://dev/startup_config.tres")
	ResourceSaver.save(session, "user://dev/startup_session.tres")
	
	EditorInterface.play_custom_scene(LEVEL_RUNNER)

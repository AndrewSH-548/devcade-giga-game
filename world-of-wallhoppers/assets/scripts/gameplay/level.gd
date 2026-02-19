@tool
extends Node2D
class_name Level

@onready var player_spawn_1: Marker2D = $PlayerSpawn1
@onready var player_spawn_2: Marker2D = $PlayerSpawn2

@onready var level_center: Marker2D = $LevelCenter

func _ready() -> void:
	if Engine.is_editor_hint():
		setup_editor()
		return
	assert(level_center != null, "Level does not have a \"Level Center\" Marker2D node as a direct child! This is required for every level")
	assert(player_spawn_1 != null, "Level could not find Player 1's Spawn!\nMake sure there is a Node2D named \"PlayerSpawn1\" which is a direct child of the level!")
	assert(player_spawn_1 != null, "Level could not find Player 2's Spawn!\nMake sure there is a Node2D named \"PlayerSpawn2\" which is a direct child of the level!")

# Update warnings when any node postion or name changes in the children
func setup_editor() -> void:
	child_order_changed.connect(func(): update_configuration_warnings())
	get_tree().node_renamed.connect(func(): update_configuration_warnings())

# Generates warnings to ensure level is setup correctly
func _get_configuration_warnings():
	var warnings = []
	
	if $LevelCenter == null:
		warnings.append("Level needs a Marker2D child named \"LevelCenter\"!")
	if $PlayerSpawn1 == null:
		warnings.append("Level needs a Marker2D child named \"PlayerSpawn1\"!")
	if $PlayerSpawn2 == null:
		warnings.append("Level needs a Marker2D child named \"PlayerSpawn2\"!")
	if $ScrollStopBottom == null:
		warnings.append("Level needs a Marker2D child named \"ScrollStopBottom\"!")
	if $ScrollStopTop == null:
		warnings.append("Level needs a Marker2D child named \"ScrollStopTop\"!")
	
	# Returning an empty array means "no warning".
	return warnings

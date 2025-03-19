extends Node

@onready var start_screen := $"Control"

var level_select_scene = preload("res://scenes/level_select.tscn") 

var multiplayer_scene: PackedScene = preload("res://scenes/multiplayer.tscn")
var singleplayer_scene: PackedScene = preload("res://scenes/singleplayer.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_screen.change_to_level_select.connect(switch_to_level_select_scene)

## load level select scene [br]
## [b]type[/b], when false means singleplayer, true means multiplayer
func switch_to_level_select_scene(type: bool) -> void:
	# remove any child GUIs
	for child in get_children():
		remove_child(child)

	var scene = level_select_scene.instantiate()
	scene.isMultiplayer = type;
	scene.load_multiplayer_level.connect(load_multiplayer_level)
	scene.load_singleplayer_level.connect(load_singleplayer_level)
	add_child(scene)


## load a multiplayer level
func load_multiplayer_level(level: SceneDesriptors):
	for child in get_children():
		remove_child(child)

	var scene = multiplayer_scene.instantiate()
	add_child(scene)
	var level_node = scene.get_node("HBoxContainer/ViewportContainerP1/SubViewport/testLevel2")
	var parent_node = level_node.get_parent()
	
	parent_node.remove_child(level_node)
	var level_scene = level.scene.instantiate()
	
	level_scene.position = Vector2(131, 297)

	parent_node.add_child(level_scene)


## load a singleplayer level
func load_singleplayer_level(level: SceneDesriptors):
	for child in get_children():
		remove_child(child)

	var scene = singleplayer_scene.instantiate()
	add_child(scene)

	var level_node = scene.get_node("ViewportContainerP1/SubViewport/testLevel")
	var parent_node = level_node.get_parent()

	parent_node.remove_child(level_node)
	
	var level_scene = level.scene.instantiate()
	
	level_scene.position = Vector2(131, 297)
	
	parent_node.add_child(level_scene)

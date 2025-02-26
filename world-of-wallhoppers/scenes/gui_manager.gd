extends Node

@onready var start_screen := $"Control"

var level_select_scene = preload("res://scenes/level_select.tscn") 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_screen.change_to_level_select.connect(load_level_select)


## load level select scene [br]
## [b]type[/b], when false means singleplayer, true means multiplayer
func load_level_select(type: bool):
	# remove the start screen
	remove_child(start_screen)
	
	var level_select = level_select_scene.instantiate()
	level_select.singleOrMultiplayer = type

	# add the level select scene
	add_child(level_select)

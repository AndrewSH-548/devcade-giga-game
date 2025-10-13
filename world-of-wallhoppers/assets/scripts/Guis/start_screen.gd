extends Control
class_name MenuStartScreen

const LEVEL_SELECT = preload("res://scenes/gui/level_select.tscn")
const TUTORIAL = preload("uid://bdnher4a7qii8")

@export var mutiplayer_button: Button
@export var singleplayer_button: Button
@export var quit_button: Button
@export var settings_button: Button
@export var tutorial_button: Button

## Quit the game
func quit() -> void:
	# unsure if this is proper, but i found it on google and. i mean. it looks right?
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST) 
	get_tree().quit()

func _ready() -> void:
	# Prevents (some) crashes from weirdness with SceneSwitcher!
	SceneSwitcher.last_scene = null

func load_level_select(is_multiplayer: bool):
	var level_select: Control = LEVEL_SELECT.instantiate()
	level_select.is_multiplayer = is_multiplayer
	get_tree().root.add_child(level_select)
	queue_free()

func load_tutorial():
	var tutorial: Node2D = TUTORIAL.instantiate()
	get_tree().root.add_child(tutorial)
	queue_free()

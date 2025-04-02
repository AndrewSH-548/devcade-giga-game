extends Control

var level_select_scene = preload("res://scenes/level_select.tscn") 

@export var mutiplayer_button: Button
@export var singleplayer_button: Button
@export var quit_button: Button
@export var settings_button: Button
@export var tutorial_button: Button

signal change_to_level_select;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var load_singleplayer: Callable = change_to_level_select_scene.bind(false)
	var load_multiplayer: Callable  = change_to_level_select_scene.bind(true)

	singleplayer_button.pressed.connect(load_singleplayer)
	mutiplayer_button.pressed.connect(load_multiplayer)

	quit_button.pressed.connect(quit)


## load level select scene [br]
## [b]type[/b], when false means singleplayer, true means multiplayer 
func change_to_level_select_scene(type: bool) -> void:
	change_to_level_select.emit(type)


## quit the game
func quit() -> void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST) # unsure if this is proper, but i found it on google and. i mean. it looks right?
	get_tree().quit()

extends Control

var level_select_scene_multiplayer_file = preload("res://scenes/level_select_multiplayer.tscn") 
var level_select_scene_singleplayer_file = preload("res://scenes/level_select_singleplayer.tscn") 

@export var mutiplayer_button: Button
@export var singleplayer_button: Button
@export var quit_button: Button
@export var settings_button: Button

@export var tutorial_button: Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var load_singleplayer: Callable = func ():
		SceneSwitcher.switch_scene_packed(level_select_scene_singleplayer_file)

	var load_multiplayer: Callable  = func ():
		SceneSwitcher.switch_scene_packed(level_select_scene_multiplayer_file)

	singleplayer_button.pressed.connect(load_singleplayer)
	mutiplayer_button.pressed.connect(load_multiplayer)

	quit_button.pressed.connect(quit)


## quit the game
func quit() -> void:
	# unsure if this is proper, but i found it on google and. i mean. it looks right?
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST) 
	get_tree().quit()

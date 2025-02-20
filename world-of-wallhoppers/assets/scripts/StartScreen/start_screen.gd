extends Control

@export var mutiplayer_button: Button
@export var singleplayer_button: Button
@export var quit_button: Button
@export var settings_button: Button

@export var tutorial_button: Button

var singleplayer_level_select_scene = preload("res://scenes/singleplayer_level_select.tscn") 
var mutiplayer_level_select_scene = preload("res://scenes/mutiplayer_level_select.tscn") 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	singleplayer_button.pressed.connect(load_level_select_scene_singleplayer)
	mutiplayer_button.pressed.connect(load_level_select_scene_mutiplayer)

	quit_button.pressed.connect(quit)

# load mutiplayer scene
func load_level_select_scene_mutiplayer():
	get_tree().change_scene_to_packed(mutiplayer_level_select_scene)

# load singleplayer scene
func load_level_select_scene_singleplayer():
	get_tree().change_scene_to_packed(singleplayer_level_select_scene)

# quit the game
func quit():
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST) # unsure if this is proper, but i found it on google and. i mean. it looks right?
	get_tree().quit()

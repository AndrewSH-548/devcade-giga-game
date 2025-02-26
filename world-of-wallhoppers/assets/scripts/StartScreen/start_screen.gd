extends Control

@export var mutiplayer_button: Button
@export var singleplayer_button: Button
@export var quit_button: Button
@export var settings_button: Button

@export var tutorial_button: Button

var change_to_level_select: Signal

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var load_singleplayer: Callable = load_level_select_scene.bind(false)
	var load_multiplayer:  Callable = load_level_select_scene.bind(true)

	singleplayer_button.pressed.connect(load_singleplayer)
	mutiplayer_button.pressed.connect(load_multiplayer)

	quit_button.pressed.connect(quit)


## load level select scene [br]
## [b]type[/b], when false means singleplayer, true means multiplayer
func load_level_select_scene(type: bool):
	change_to_level_select.emit(type)


## quit the game
func quit():
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST) # unsure if this is proper, but i found it on google and. i mean. it looks right?
	get_tree().quit()

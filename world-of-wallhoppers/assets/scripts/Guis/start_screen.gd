extends Control
class_name MenuStartScreen

const LEVEL_SELECT = preload("res://scenes/gui/level_select.tscn")
const RECORDS = preload("res://scenes/gui/records/records.tscn")
const TUTORIAL_MENU = preload("res://scenes/gui/tutorial/tutorial_menu.tscn")

@export var mutiplayer_button: Button
@export var singleplayer_button: Button
@export var quit_button: Button
@export var records_button: Button
@export var settings_button: Button
@export var tutorial_button: Button

@onready var buttons: Array[Button] = [
	mutiplayer_button,
	singleplayer_button,
	quit_button,
	records_button,
	settings_button,
	tutorial_button,
]

static var last_selected: int = 0

## Quit the game
func quit() -> void:
	# unsure if this is proper, but i found it on google and. i mean. it looks right?
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST) 
	get_tree().quit()

func _ready() -> void:
	if last_selected >= 0 and last_selected < buttons.size():
		buttons[last_selected].grab_focus()

func load_level_select(is_multiplayer: bool):
	var level_select: Control = LEVEL_SELECT.instantiate()
	level_select.is_multiplayer = is_multiplayer
	unload_and_switch(level_select)

func load_records() -> void:
	var records: Control = RECORDS.instantiate()
	unload_and_switch(records)

func load_tutorial():
	var tutorial: Control = TUTORIAL_MENU.instantiate()
	unload_and_switch(tutorial)

func unload_and_switch(new_root: Node):
	var index: int = -1
	for i in range(buttons.size()):
		if buttons[i] == get_viewport().gui_get_focus_owner():
			index = i
	last_selected = index
	print(last_selected)
	get_tree().root.add_child(new_root)
	queue_free()

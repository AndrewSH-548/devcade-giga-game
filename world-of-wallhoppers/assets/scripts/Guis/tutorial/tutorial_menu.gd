extends Control

const BASICS = "res://scenes/levels/tutorial.tscn"
const ABILITIES = "res://scenes/gui/tutorial/ability_tutorial_menu.tscn"
@onready var button_basics: Button = $VBoxContainer/ButtonBasics

func _ready():
	button_basics.grab_focus()

func load_start_screen() -> void:
	get_tree().change_scene_to_file("res://scenes/start_screen.tscn")
	queue_free()

func load_basics():
	get_tree().change_scene_to_file(BASICS)
	queue_free()

func load_abilities() -> void:
	get_tree().change_scene_to_file(ABILITIES)
	queue_free()

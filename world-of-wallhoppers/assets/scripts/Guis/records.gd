extends Control

@onready var board_1: LeaderboardTable = $VBoxContainer/Boards/MarginContainer/ScrollContainer/VBoxContainer/Board
@onready var board_2: LeaderboardTable = $VBoxContainer/Boards/MarginContainer/ScrollContainer/VBoxContainer/Board2
@onready var board_3: LeaderboardTable = $VBoxContainer/Boards/MarginContainer/ScrollContainer/VBoxContainer/Board3

@onready var scroll: ScrollContainer = $VBoxContainer/Boards/MarginContainer/ScrollContainer

@onready var back: Button = $VBoxContainer/TopContainer/Back
@onready var up: Button = $VBoxContainer/Boards/Up
@onready var down: Button = $VBoxContainer/Boards/Down

func _ready() -> void:
	board_1.leaderboard = TimeManager.leaderboards["Jungle"]
	board_2.leaderboard = TimeManager.leaderboards["Volcano"]
	board_3.leaderboard = TimeManager.leaderboards["Reef"]
	back.grab_focus()
	update_all()

func update_all():
	board_1.update()
	board_2.update()
	board_3.update()

func load_start_screen() -> void:
	get_tree().change_scene_to_file("res://scenes/start_screen.tscn")
	queue_free()

func _process(delta: float) -> void:
	if up.button_pressed:
		scroll.scroll_vertical -= int(delta * 1000)
	if down.button_pressed:
		scroll.scroll_vertical += int(delta * 1000)

extends Control

@onready var board_1: LeaderboardTable = $VBoxContainer/VScrollBar/MarginContainer/VBoxContainer/Board
@onready var board_2: LeaderboardTable = $VBoxContainer/VScrollBar/MarginContainer/VBoxContainer/Board2
@onready var board_3: LeaderboardTable = $VBoxContainer/VScrollBar/MarginContainer/VBoxContainer/Board3

@onready var back: Button = $VBoxContainer/TopContainer/Back

func _ready() -> void:
	board_1.leaderboard = LevelLeaderboard.new("Jungle")
	board_2.leaderboard = LevelLeaderboard.new("Volcano")
	board_3.leaderboard = LevelLeaderboard.new("Reef")
	back.grab_focus()
	update_all()

func update_all():
	board_1.update()
	board_2.update()
	board_3.update()

func load_start_screen() -> void:
	get_tree().change_scene_to_file("res://scenes/start_screen.tscn")
	queue_free()

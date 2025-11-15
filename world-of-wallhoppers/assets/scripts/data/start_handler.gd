extends Node

func _ready() -> void:
	Definitions.define()
	LevelLeaderboard.new(&"Jungle")

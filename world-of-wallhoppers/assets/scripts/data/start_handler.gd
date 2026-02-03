extends Node

func _ready() -> void:
	Definitions.define()
	TimeManager.load_leaderboards_from_disk()
	#LevelLeaderboard.new(&"Jungle")

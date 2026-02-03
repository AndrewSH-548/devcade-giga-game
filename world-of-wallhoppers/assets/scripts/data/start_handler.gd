extends Node

func _ready() -> void:
	Definitions.load_definitions()
	TimeManager.load_leaderboards_from_disk()
	#LevelLeaderboard.new(&"Jungle")

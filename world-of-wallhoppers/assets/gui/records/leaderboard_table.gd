extends VBoxContainer
class_name LeaderboardTable

@onready var title: Label = $Title
@onready var records: Label = $Records

var leaderboard: LevelLeaderboard

func update():
	leaderboard.update_all()
	title.text = leaderboard.level
	records.text = leaderboard.string_best_records()

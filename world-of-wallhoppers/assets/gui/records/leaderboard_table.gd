extends VBoxContainer
class_name LeaderboardTable

@onready var title: Label = $Title
@onready var records: Label = $Records

var leaderboard: LevelLeaderboard

func update():
	leaderboard.update_all()
	title.text = leaderboard.level
	records.text = best_records()

func best_records(max_amount: int = 3) -> String:
	var result: String = ""
	var amount: int = 0
	for record in leaderboard.best_records:
		if amount >= max_amount:
			break
		amount += 1
		var time: String = str(record.time).pad_decimals(3)
		var line: String = (record.player + ': ' + record.character).rpad(30 - time.length()) + time
		result += line + '\n'
	return result.substr(0, result.length() - 1)

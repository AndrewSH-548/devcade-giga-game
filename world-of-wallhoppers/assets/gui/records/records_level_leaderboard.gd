extends Control
class_name RecordsLevelLeaderboard

@onready var title: Label = $Vertical/Title
@onready var records: Label = $Vertical/Records

func setup(level: LevelDefinition):
	TimeManager.load_leaderboards_from_disk()
	title.text = "<--    " + level.name + "    -->"
	records.text = TimeManager.leaderboards[level.name].string_best_records(12)

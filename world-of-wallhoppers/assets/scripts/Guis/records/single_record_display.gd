extends Panel
class_name SingleRecordDispay

@onready var placement: Label = $HBoxContainer/Placement
@onready var player: Label = $HBoxContainer/NamePanel/NameVBox/Player
@onready var character: Label = $HBoxContainer/NamePanel/NameVBox/Character
@onready var time: Label = $HBoxContainer/TimePanel/TimeVBox/Time

func setup(record: LevelLeaderboard.SingleRecord) -> void:
	placement.text = "#?"
	player.text = record.player
	character.text = record.character
	time.text = str("%3.2f" % record.time)

extends Panel
class_name SingleRecordDispay

@onready var placement: Label = $HBoxContainer/Placement
@onready var player: Label = $HBoxContainer/NamePanel/NameVBox/Player
@onready var time: Label = $HBoxContainer/TimePanel/TimeVBox/Time
@onready var character: TextureRect = $HBoxContainer/Character

func setup(record: LevelLeaderboard.SingleRecord, placement_number: int) -> void:
	placement.text = "#" + str(placement_number)
	
	match placement_number:
		1: placement.modulate = Color.GOLDENROD
		2: placement.modulate = Color.SILVER
		3: placement.modulate = Color.CHOCOLATE
	
	player.text = record.player
	time.text = str("%3.2f" % record.time)
	character.texture = Definitions.get_character(record.character).button_texture

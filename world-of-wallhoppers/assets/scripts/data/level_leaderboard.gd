class_name LevelLeaderboard
## This class represents a Leaderboard for a single level

## Maps characters to a dictionary of records
var _character_records: Dictionary[StringName, _CharacterRecord] = {}

func _init() -> void:
	for character in Definitions.characters:
		_character_records.set(character, _CharacterRecord.new())

class _CharacterRecord:
	## Maps 
	var _player_records: Dictionary[StringName, float] = {}
	func update_record(player: String, time: float):
		var current_record: float = _player_records.get(player, INF)
		if time < current_record:
			_player_records.set(player, time)

func update_record(character: StringName, player: String, time: float):
	assert(character in _character_records.keys())
	var character_record: _CharacterRecord = _character_records[character]
	character_record.update_record(player, time)

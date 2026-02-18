extends Resource
class_name LevelLeaderboard
## This class represents a Leaderboard for a single level

@export var level: StringName
@export var records: Array[SingleRecord] = []
@export var best_records: Array[SingleRecord] = []

const SINGLE_RECORD_DISPLAY = preload("uid://dm8xvhnd7y5yw")

func _init(level_name: StringName) -> void:
	level = level_name

class SingleRecord:
	extends Resource
	@export var player: StringName
	@export var character: StringName
	@export var time: float
	func faster_than(other: SingleRecord) -> bool:
		return time < other.time
	func slower_than(other: SingleRecord) -> bool:
		return time > other.time

func add_record(player: StringName, character: StringName, time: float):
	var record: SingleRecord = SingleRecord.new()
	
	record.player = player
	record.character = character
	record.time = time
	
	var index: int = -1
	for r in records:
		index += 1
		if r.player == player and r.character == character:
			if r.time > time:
				records[index] = record
			return
	
	records.append(record)

func update_all() -> void:
	calculate_only_best()
	sort_all()

func sort_all():
	records = _records_merge_sort(records)
	best_records = _records_merge_sort(best_records)

## Returns a string representation of the best records for each player on this Leaderboard's Level
func string_best_records(max_amount: int = 3) -> String:
	update_all()
	var result: String = ""
	var amount: int = 0
	for record in best_records:
		if amount >= max_amount:
			break
		amount += 1
		result += string_record(record) + '\n'
	return result.substr(0, result.length() - 1)

## Returns a string representation of a "SingleRecord" object
func string_record(record: SingleRecord):
	var time: String = str(record.time).pad_decimals(1)
	return (record.player + ': ' + record.character).rpad(20 - time.length()) + time

func calculate_only_best():
	best_records = []
	var player_best: Dictionary[StringName, SingleRecord]
	for record in records:
		if record.player not in player_best.keys():
			player_best[record.player] = record
		elif record.time < player_best[record.player].time:
			player_best[record.player] = record
	best_records = player_best.values()
	best_records = _records_merge_sort(best_records)

func _records_merge_sort(array: Array[SingleRecord]) -> Array[SingleRecord]:
	if array.size() <= 1:
		return array
	var a: Array[SingleRecord] = array.duplicate()
	var half_size: int = int(a.size() / 2.0)
	var left: Array[SingleRecord] = a.slice(0, half_size)
	var right: Array[SingleRecord] = a.slice(half_size, a.size())
	
	return _sorted_combine(_records_merge_sort(left), _records_merge_sort(right))

func _sorted_combine(array_1: Array[SingleRecord], array_2: Array[SingleRecord]) -> Array[SingleRecord]:
	var dest: Array[SingleRecord] = []
	var size_1: int = array_1.size()
	var size_2: int = array_2.size()
	dest.resize(size_1 + size_2)
	var index_dest: int = 0
	var index_1: int = 0
	var index_2: int = 0
	while index_1 < size_1 and index_2 < size_2:
		var record_1: SingleRecord = array_1[index_1]
		var record_2: SingleRecord = array_2[index_2]
		if record_1.faster_than(record_2):
			dest[index_dest] = record_1
			index_1 += 1
		else:
			dest[index_dest] = record_2
			index_2 += 1
		index_dest += 1
	while index_1 < size_1:
		dest[index_dest] = array_1[index_1]
		index_1 += 1
		index_dest += 1
	while index_2 < size_2:
		dest[index_dest] = array_2[index_2]
		index_2 += 1
		index_dest += 1
	return dest

# Packs the leaderboard into the folling format:
#
# {
#    level: "Level Name"
#    records: [
#       { player: "my name", character:"Hip", time: 21.0 },
#       { player: "joe", character:"Reign", time: 19.1 },
#       { player: "doe", character:"Scoria", time: 23.4 },
#    ]
# }

func pack() -> Dictionary:
	var packed: Dictionary = {}
	packed["level"] = level
	var packed_records: Array = []
	for record in records:
		packed_records.append({ "player": record.player, "character": record.character, "time": record.time })
	packed["records"] = packed_records
	return packed

static func from_packed(packed_leaderboard: Dictionary) -> LevelLeaderboard:
	var new: LevelLeaderboard = LevelLeaderboard.new(packed_leaderboard["level"])
	var packed_records: Array = packed_leaderboard["records"]
	for record in packed_records:
		var unpacked_record: SingleRecord = SingleRecord.new()
		unpacked_record.player = record["player"]
		unpacked_record.character = record["character"]
		unpacked_record.time = record["time"]
		new.records.append(unpacked_record)
	return new

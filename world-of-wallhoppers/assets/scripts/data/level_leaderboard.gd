class_name LevelLeaderboard
## This class represents a Leaderboard for a single level

var level: StringName
var records: Array[SingleRecord] = []
var best_records: Array[SingleRecord] = []

func _init(level_name: StringName) -> void:
	level = level_name
	for i in range(100):
		add_record(["A", "B", "C", "D", "E"].pick_random(), str(randi_range(0, 5)), randi_range(0, 20))
	update_all()
	for r in records:
		print(r.time, " : ", r.player, " using: ", r.character)
	print("\n--- BEST ---\n")
	for r in best_records:
		print(r.time, " : ", r.player, " using: ", r.character)

class SingleRecord:
	var player: StringName
	var character: StringName
	var time: float
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
	if array.size() == 1:
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

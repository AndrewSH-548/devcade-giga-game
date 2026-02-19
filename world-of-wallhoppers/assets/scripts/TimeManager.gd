extends Node

# I've added a version number, so old versions of the save data won't be used.
const save_path = "user://leaderboards_ver_002.save"; ## The path to the file the leaderboards data will be saved to

var leaderboards: Dictionary[StringName, LevelLeaderboard] = {}

var current_time_trial_time: float = 0; ## the current singleplayer time

func do_time_trial_time_tick(value: float) -> void: ## increases the temporary_singleplayer_time by (value)
	var temp = current_time_trial_time + value; # the following code is to the time sticks to 1 decimal place
	current_time_trial_time = snapped(temp, 0.1);

func get_time_trial_time(): ## returns the current singleplayer time, does not add anything to the leaderboards
	return current_time_trial_time

func reset_timer():
	current_time_trial_time = 0

func pack_leaderboards() -> Dictionary:
	var packed_leaderboards: Dictionary = {}
	for leaderboard: LevelLeaderboard in leaderboards.values():
		packed_leaderboards[leaderboard.level] = leaderboard.pack()
	return packed_leaderboards

func save_and_get_current_record(player_name: String, session_info: SessionInfo) -> LevelLeaderboard.SingleRecord:
	var level: StringName = session_info.level_info.name
	var character: StringName = session_info.characters[0].name
	assert(level in leaderboards.keys())
	var leaderboard: LevelLeaderboard = leaderboards.get(level)
	var record: LevelLeaderboard.SingleRecord = leaderboard.make_record(player_name, character, current_time_trial_time)
	leaderboard.add_record(record)
	leaderboard.update_all()
	save_leaderboards_to_disk()
	return record

func save_leaderboards_to_disk(): ## save all leaderboards to "res://save_data/leaderboards.save"
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(pack_leaderboards())
	print_debug("Saved Leaderboards to Disk")
	file.close()

func load_leaderboards_from_disk(): ## load all leaderboards from "res://save_data/leaderboards.save"
	var packed_leaderboards: Dictionary
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		# Set leaderboards from save data
		var possible_leaderboards = file.get_var()
		if possible_leaderboards == null:
			possible_leaderboards = {}
		packed_leaderboards = possible_leaderboards
		print_debug("Loaded Leaderboards from Disk")
		file.close()
	else:
		print_debug("No leaderboard data found...")
	for level in Definitions.levels:
		if packed_leaderboards.get(level.name) == null:
			packed_leaderboards[level.name] = { "level": level.name, "records": []}
	for level_leaderboard in packed_leaderboards.values():
		var leaderboard: LevelLeaderboard = LevelLeaderboard.from_packed(level_leaderboard)
		leaderboards[level_leaderboard["level"]] = leaderboard
		leaderboard.update_all()

func clear_all_data(): ## clear leaderboard data from "res://save_data/leaderboards.save"
	pass

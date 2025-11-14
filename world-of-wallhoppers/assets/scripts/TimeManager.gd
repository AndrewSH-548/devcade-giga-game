extends Node

# I've added a version number, so old versions of the save data won't be used.
# If breaking changes are made to the file, increment the version number
# Complete overhauls should change the 1st number and reset the second to 0, small overhauls change the second
const save_path = "res://save_data/leaderboard_data_0.1.save"; ## The path to the file the leaderboards data will be saved to

## Leaderboards[LevelName, Scores[PlayerName, Record]]
var leaderboards: Dictionary = {}

var current_time_trial_time: float = 0; ## the current singleplayer time

func _ready() -> void:
	load_leaderboard_data(); # load data on start
	
	#clear_all_data(); # uncomment and run to clear data
	#save_leaderboards_to_disk;

func do_time_trial_time_tick(value: float) -> void: ## increases the temporary_singleplayer_time by (value)
	var temp = current_time_trial_time + value; # the following code is to the time sticks to 1 decimal place
	current_time_trial_time = snapped(temp, 0.1);

func get_time_trial_time(): ## returns the current singleplayer time, does not add anything to the leaderboards
	return current_time_trial_time

## Returns and resets the temporary_singleplayer_time given the (player_name)
## and the (level) (volcano_singleplayer, volcano_multiplayer, jungle_singleplayer, etc,). Updates the leaderboard for the given player and time
func get_and_save_current_time_and_clear(level: String, player_name: String) -> float: 
	assert(level in leaderboards.keys())
	
	var leaderboard: Dictionary = leaderboards.get(level)
	var current_score = leaderboard.get(player_name)
	if current_score == null or current_score > current_time_trial_time:
		leaderboard.set(player_name, current_time_trial_time)
	
	save_leaderboards_to_disk()
	current_time_trial_time = 0
	return current_time_trial_time

func save_leaderboards_to_disk(): ## save all leaderboards to "res://save_data/leaderboards.save"
	var file = FileAccess.open(save_path, FileAccess.WRITE);
	file.store_var(leaderboards)
	print_debug("Saved Leaderboards to Disk")
	file.close();

func load_leaderboard_data(): ## load all leaderboards from "res://save_data/leaderboards.save"
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ);
		# Set leaderboards from save data
		var possible_leaderboards = file.get_var()
		if possible_leaderboards == null: possible_leaderboards = {}
		leaderboards = possible_leaderboards
		print_debug("Loaded Leaderboards from Disk")
		file.close();
	else:
		print_debug("No leaderboard data saved...");

func clear_all_data(): ## clear leaderboard data from "res://save_data/leaderboards.save"
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.WRITE)
		leaderboards = {}
		file.store_var(leaderboards)
		file.close()

extends Node

const save_path = "res://save_data/leaderboards.save"; ## The path to the file the leaderboards data will be saved to

var current_leaderboard = {} ## holds the current leaderboard, which is dynamically set throughout the game

var volcano_leaderboard = {}; ## leaderboard for completion times 
var jungle_leaderboard = {};

var singleplayer_time: float = 0; ## the current singleplayer time

func _ready() -> void:
	load_data(); # load data on start
	
	#clear_all_data(); # uncomment and run to clear data
	#save_data();

func increase_singleplayer_time(value: float) -> void: ## increases the temporary_singleplayer_time by (value)
	var temp = singleplayer_time + value; # the following code is to the time sticks to 1 decimal place
	singleplayer_time = snapped(temp, 0.1);

func return_singleplayer_time(): ## returns the current singleplayer time, does not add anything to the leaderboards
	return singleplayer_time;

## Returns and resets the temporary_singleplayer_time given the (player_name), defaulted to 'XXXXX', 
## and the (level) (volcano_singleplayer, volcano_multiplayer, jungle_singleplayer, etc,). Updates the leaderboard for the given player and time
func return_and_reset_temporary_singleplayer_time(level: String, player_name: String = "XXXXXXXX") -> float: 
	var temp = singleplayer_time;
	
	match level.to_lower():
		"volcano":
			volcano_leaderboard[player_name] = temp;
			set_current_leaderboard(level);
			#volcano_singleplayer_leaderboard.sort(); # sorts the leaderboard in descending order
		"jungle":
			jungle_leaderboard[player_name] = temp;
			set_current_leaderboard(level);
		_:
			print_debug("ERROR: Invalid level -> " + level);
	
	save_data();
	singleplayer_time = 0; # reset the time
	return temp;

func set_current_leaderboard(level: String) -> void: ## sets the current leaderboard to the respective (level)'s leaderboard
	match level.to_lower():
		"volcano":
			current_leaderboard = volcano_leaderboard;
		"jungle":
			current_leaderboard = jungle_leaderboard;
		_:
			print_debug("ERROR: Invalid level -> " + level);
	
func save_data(): ## save all leaderboards to "res://save_data/leaderboards.save"
	var file = FileAccess.open(save_path, FileAccess.WRITE);
	# Store leaderboards
	file.store_var(volcano_leaderboard);
	file.store_var(jungle_leaderboard);
	print_debug("Data Saved");
	file.close();


func load_data(): ## load all leaderboards from "res://save_data/leaderboards.save"
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ);
		# Set leaderboards from save data
		volcano_leaderboard = file.get_var();
		jungle_leaderboard = file.get_var();
		print_debug("Data Loaded");
		file.close();
	else:
		print_debug("No leaderboard data saved...");

func clear_all_data(): ## clear leaderboard data from "res://save_data/leaderboards.save"
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.WRITE);
		volcano_leaderboard = {};
		jungle_leaderboard = {};
		file.store_var(volcano_leaderboard);
		file.store_var(jungle_leaderboard);
		file.close();

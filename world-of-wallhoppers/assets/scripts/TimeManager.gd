extends Node

var current_leaderboard = {} ## holds the current leaderboard, which is dynamically set throughout the game

var volcano_leaderboard = {}; ## leaderboard for completion times (TODO: Change to a Dictionary and allow for player's usernames with username:time as the key:value
var jungle_leaderboard = {};

var temporary_singleplayer_time: float = 0; ## the current singleplayer time

func increase_temporary_singleplayer_time(value: float) -> void: ## increases the temporary_singleplayer_time by (value)
	var temp = temporary_singleplayer_time + value; # the following code is to the time sticks to 1 decimal place
	temporary_singleplayer_time = snapped(temp, 0.1);


func return_and_reset_temporary_singleplayer_time(level: String, player_name: String = "XXXXX") -> float: ## returns and resets the temporary_singleplayer_time given the (player_name), defaulted to 'XXXXX', and the (level) (volcano_singleplayer, volcano_multiplayer, jungle_singleplayer, etc,)
	var temp = temporary_singleplayer_time;
	
	match level.to_lower():
		"volcano":
			volcano_leaderboard[player_name] = temp;
			set_current_leaderboard(level);
			#volcano_singleplayer_leaderboard.sort(); # sorts the leaderboard in descending order
		"jungle":
			volcano_leaderboard[player_name] = temp;
			set_current_leaderboard(level);
		_:
			print_debug("ERROR: Invalid level -> " + level);
			
	temporary_singleplayer_time = 0; # reset the time
	return temp;

func set_current_leaderboard(level: String) -> void: ## sets the current leaderboard to the respective (level)'s leaderboard
	match level.to_lower():
		"volcano":
			current_leaderboard = volcano_leaderboard;
		"jungle":
			current_leaderboard = jungle_leaderboard;
		_:
			print_debug("ERROR: Invalid level -> " + level);
	

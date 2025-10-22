extends Node

var leaderboard: Array; ## leaderboard for completion times (TODO: Change to a Dictionary and allow for player's usernames with username:time as the key:value

var temporary_singleplayer_time: float = 0; ## the current singleplayer time

func increase_temporary_singleplayer_time(value: float) -> void: ## increases the temporary_singleplayer_time by (value)
	var temp = temporary_singleplayer_time + value; # the following code is to the time sticks to 1 decimal place
	temporary_singleplayer_time = snapped(temp, 0.1);

func return_and_reset_temporary_singleplayer_time() -> float: ## returns and resets the temporary_singleplayer_time
	var temp = temporary_singleplayer_time;
	leaderboard.append(temp);
	leaderboard.sort(); # sorts the leaderboard in descending order
	temporary_singleplayer_time = 0; # reset the time
	return temp;

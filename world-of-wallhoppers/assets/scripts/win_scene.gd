extends Control

@onready var time_label: Label = $VBoxContainer/TimeLabel
@onready var leaderboard_title: Label = $VBoxContainer/LeaderboardTitle
@onready var leaderboard: Label = $VBoxContainer/Leaderboard

func _ready() -> void:
	$"VBoxContainer/Level Select".grab_focus();
	time_label.text = "Completion Time: " + str(TimeManager.return_and_reset_temporary_singleplayer_time(LevelManager.current_level));
	leaderboard_title.text = "Leaderboard";
	leaderboard.text = "";
	
	var leaderboard_values = TimeManager.current_leaderboard.values(); # gets all the values in the leaderboard
	var player_name = "_____"; # default player name
	leaderboard_values.sort();
	for i in range(len(leaderboard_values)): # displays the current_leaderboard
		for player in TimeManager.current_leaderboard: # loop through all the players in the leaderboard, if the playername matches the time, then use it and stop the loop
			if(TimeManager.current_leaderboard.get(player) == leaderboard_values[i]):
				player_name = player;
				break;
		leaderboard.text += player_name + " ---------- " + str(leaderboard_values[i]) + "s\n";


func _on_level_select_pressed() -> void:
	var level_select: Control =  MenuStartScreen.LEVEL_SELECT.instantiate()
	level_select.is_multiplayer = get_tree().get_first_node_in_group("splitscreen").current_session_info.is_multiplayer
	get_tree().root.add_child(level_select)
	get_tree().get_first_node_in_group("splitscreen").queue_free()
	queue_free()

func _on_quit_pressed() -> void:
	get_tree().quit(); 

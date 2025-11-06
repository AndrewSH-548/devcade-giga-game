extends Control

@onready var volcano_leaderboard: Label = $VBoxContainer/VScrollBar/MarginContainer/VBoxContainer/Volcano/VolcanoLeaderboard
@onready var jungle_leaderboard: Label = $VBoxContainer/VScrollBar/MarginContainer/VBoxContainer/Jungle/JungleLeaderboard

func _ready() -> void:
	display_leaderboard("volcano");
	display_leaderboard("jungle");

func display_leaderboard(level: String) -> void:
	var player_name = "";
	var leaderboard = volcano_leaderboard;
	match level.to_lower():
		"volcano":
			leaderboard = volcano_leaderboard;
		"jungle":
			leaderboard = jungle_leaderboard;
		_:
			print_debug("Error: Invalid level entered.");
	TimeManager.set_current_leaderboard(level);
			
	var leaderboard_values = TimeManager.current_leaderboard.values(); # gets all the values in the leaderboard
		# sorts the values so that the leaderboard is displayed from fastest to slowest times.
	leaderboard_values.sort();
	
	leaderboard.text = "";
	for i in range(len(leaderboard_values)): # displays the current_leaderboard
		for player in TimeManager.current_leaderboard: # loop through all the players in the leaderboard, if the playername matches the time, then use it and stop the loop
			if(TimeManager.current_leaderboard.get(player) == leaderboard_values[i]):
				player_name = player;
				break;
		leaderboard.text += player_name + " ---------- " + str(leaderboard_values[i]) + "s\n";


func load_start_screen() -> void:
	get_tree().change_scene_to_file("res://scenes/start_screen.tscn")
	queue_free()

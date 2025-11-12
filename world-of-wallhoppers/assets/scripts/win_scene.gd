extends Control

@onready var time_label: Label = $VBoxContainer/TimeLabel
@onready var leaderboard_title: Label = $VBoxContainer/LeaderboardTitle
@onready var leaderboard: Label = $VBoxContainer/Leaderboard

@onready var name_input: Button = $"VBoxContainer/Name Input"
@onready var player_name_label: Label = $NameInputPanel/NameInputContainer/Panel/PlayerNameLabel
@onready var name_input_container: VBoxContainer = $NameInputPanel/NameInputContainer
@onready var name_input_panel: Panel = $NameInputPanel

@onready var level_select_button: Button = $"VBoxContainer/Level Select"

var player_name = "XXXXX";

func _ready() -> void:
	$"VBoxContainer/Level Select".grab_focus();
	time_label.text = "Completion Time: " + str(TimeManager.return_singleplayer_time());
	leaderboard_title.text = "Leaderboard";
	leaderboard.text = "";
	player_name = "XXXXX"; # default player name

	name_input_panel.show();

func set_leaderboard() -> void: ## Set the leaderboard with the new time
	time_label.text = "Completion Time: " + str(TimeManager.return_and_reset_temporary_singleplayer_time(LevelManager.current_level, player_name));
	var leaderboard_values = TimeManager.current_leaderboard.values(); # gets all the values in the leaderboard
		# sorts the values so that the leaderboard is displayed from fastest to slowest times.
	leaderboard_values.sort();
	for i in range(len(leaderboard_values)): # displays the current_leaderboard
		for player in TimeManager.current_leaderboard: # loop through all the players in the leaderboard, if the playername matches the time, then use it and stop the loop
			if(TimeManager.current_leaderboard.get(player) == leaderboard_values[i]):
				player_name = player;
				break;
		leaderboard.text += player_name + " ----- " + str(leaderboard_values[i]) + "s\n";

func _on_level_select_pressed() -> void:
	var level_select: Control =  MenuStartScreen.LEVEL_SELECT.instantiate()
	level_select.is_multiplayer = get_tree().get_first_node_in_group("splitscreen").current_session_info.is_multiplayer
	get_tree().root.add_child(level_select)
	get_tree().get_first_node_in_group("splitscreen").queue_free()
	queue_free()

func _on_quit_pressed() -> void:
	get_tree().get_first_node_in_group("splitscreen").queue_free()
	get_tree().change_scene_to_file("res://scenes/start_screen.tscn")
	queue_free()

func _on_name_input_pressed() -> void:
	name_input_panel.show();

func _on_submit_button_pressed() -> void:
	player_name = player_name_label.text;
	name_input.text = player_name_label.text;
	name_input_panel.hide();
	level_select_button.grab_focus()
	
	set_leaderboard(); # submit leaderboard on name_input_pressed

func _on_a_pressed() -> void:
	player_name_label.text += "A";

func _on_b_pressed() -> void:
	player_name_label.text += "B";

func _on_c_pressed() -> void:
	player_name_label.text += "C";

func _on_d_pressed() -> void:
	player_name_label.text += "D";

func _on_e_pressed() -> void:
	player_name_label.text += "E";

func _on_f_pressed() -> void:
	player_name_label.text += "F";

func _on_g_pressed() -> void:
	player_name_label.text += "G";

func _on_h_pressed() -> void:
	player_name_label.text += "H";

func _on_i_pressed() -> void:
	player_name_label.text += "I";

func _on_j_pressed() -> void:
	player_name_label.text += "J";

func _on_k_pressed() -> void:
	player_name_label.text += "K";

func _on_l_pressed() -> void:
	player_name_label.text += "L";

func _on_m_pressed() -> void:
	player_name_label.text += "M";

func _on_n_pressed() -> void:
	player_name_label.text += "N";

func _on_o_pressed() -> void:
	player_name_label.text += "O";

func _on_p_pressed() -> void:
	player_name_label.text += "P";

func _on_q_pressed() -> void:
	player_name_label.text += "Q";

func _on_r_pressed() -> void:
	player_name_label.text += "R";

func _on_s_pressed() -> void:
	player_name_label.text += "S";

func _on_t_pressed() -> void:
	player_name_label.text += "T";

func _on_u_pressed() -> void:
	player_name_label.text += "U";

func _on_v_pressed() -> void:
	player_name_label.text += "V";

func _on_w_pressed() -> void:
	player_name_label.text += "W";

func _on_x_pressed() -> void:
	player_name_label.text += "X";
	
func _on_y_pressed() -> void:
	player_name_label.text += "Y";

func _on_z_pressed() -> void:
	player_name_label.text += "Z";


func _on_delete_button_pressed() -> void:
	player_name_label.text = player_name_label.text.left(player_name_label.text.length() - 1); # remove the last letter in the name

func _on_clear_button_pressed() -> void:
	player_name_label.text = ""; # remove all characters in the name

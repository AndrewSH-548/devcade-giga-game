extends Control
class_name WinScene

@onready var time_label: Label = $Results/TimeLabel
@onready var leaderboard_title: Label = $Results/LeaderboardTitle
@onready var leaderboard: Label = $Results/Leaderboard
@onready var results: VBoxContainer = $Results

@onready var name_input: Button = $"Results/Name Input"
@onready var player_name_label: Label = $EnterRecord/NameInputContainer/Panel/PlayerNameLabel
@onready var name_input_container: VBoxContainer = $EnterRecord/NameInputContainer
@onready var name_input_panel: Panel = $EnterRecord
@onready var d_key: Button = $EnterRecord/NameInputContainer/GridContainer/D
@onready var winner_label: Label = $EnterRecord/Winner
@onready var winner_multiplayer: Label = $Results/WinnerMultiplayer

@onready var level_select_button: Button = $"Results/Level Select"

var session_info: SessionInfo
var player_name = "";

func _ready() -> void:
	session_info = SessionInfo.pass_along
	if session_info.is_multiplayer:
		winner_label.text = "Player " + str(session_info.winner) + " Won!"
		winner_multiplayer.text = winner_label.text
		winner_label.visible = false
	else:
		winner_label.text = "Congradulations!"
		winner_multiplayer.visible = false
	get_tree().get_first_node_in_group("splitscreen").queue_free()
	if not session_info.is_multiplayer:
		results.focus_behavior_recursive = Control.FOCUS_BEHAVIOR_DISABLED
		name_input_panel.focus_behavior_recursive = Control.FOCUS_BEHAVIOR_INHERITED
		results.visible = false
		name_input_panel.visible = true
		d_key.grab_focus()
		name_input_panel.show();
	else:
		results.focus_behavior_recursive = Control.FOCUS_BEHAVIOR_INHERITED
		name_input_panel.focus_behavior_recursive = Control.FOCUS_BEHAVIOR_DISABLED
		results.visible = true
		name_input_panel.visible = false
		time_label.visible = false
		leaderboard_title.visible = false
		leaderboard.visible = false
		level_select_button.grab_focus()
	time_label.text = "Completion Time: " + str(TimeManager.return_singleplayer_time());
	leaderboard_title.text = "Leaderboard";
	leaderboard.text = "";
	player_name = ""


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

func _physics_process(_delta: float) -> void:
	player_name_label.text = player_name if player_name != "" else "Enter Name..."

func _on_level_select_pressed() -> void:
	var level_select: Control =  MenuStartScreen.LEVEL_SELECT.instantiate()
	level_select.is_multiplayer = session_info.is_multiplayer
	session_info = null
	get_tree().root.add_child(level_select)
	queue_free()

func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/start_screen.tscn")
	queue_free()

func _on_name_input_pressed() -> void:
	name_input_panel.show();

func _on_submit_button_pressed() -> void:
	name_input.text = player_name
	name_input_panel.hide();
	results.focus_behavior_recursive = Control.FOCUS_BEHAVIOR_INHERITED
	name_input_panel.focus_behavior_recursive = Control.FOCUS_BEHAVIOR_DISABLED
	results.visible = true
	name_input_panel.visible = false
	level_select_button.grab_focus()
	set_leaderboard(); # submit leaderboard on name_input_pressed

func _on_a_pressed() -> void:
	player_name += "A";

func _on_b_pressed() -> void:
	player_name += "B";

func _on_c_pressed() -> void:
	player_name += "C";

func _on_d_pressed() -> void:
	player_name += "D";

func _on_e_pressed() -> void:
	player_name += "E";

func _on_f_pressed() -> void:
	player_name += "F";

func _on_g_pressed() -> void:
	player_name += "G";

func _on_h_pressed() -> void:
	player_name += "H";

func _on_i_pressed() -> void:
	player_name += "I";

func _on_j_pressed() -> void:
	player_name += "J";

func _on_k_pressed() -> void:
	player_name += "K";

func _on_l_pressed() -> void:
	player_name += "L";

func _on_m_pressed() -> void:
	player_name += "M";

func _on_n_pressed() -> void:
	player_name += "N";

func _on_o_pressed() -> void:
	player_name += "O";

func _on_p_pressed() -> void:
	player_name += "P";

func _on_q_pressed() -> void:
	player_name += "Q";

func _on_r_pressed() -> void:
	player_name += "R";

func _on_s_pressed() -> void:
	player_name += "S";

func _on_t_pressed() -> void:
	player_name += "T";

func _on_u_pressed() -> void:
	player_name += "U";

func _on_v_pressed() -> void:
	player_name += "V";

func _on_w_pressed() -> void:
	player_name += "W";

func _on_x_pressed() -> void:
	player_name += "X";
	
func _on_y_pressed() -> void:
	player_name += "Y";

func _on_z_pressed() -> void:
	player_name += "Z";


func _on_delete_button_pressed() -> void:
	player_name = player_name.left(player_name.length() - 1); # remove the last letter in the name

func _on_clear_button_pressed() -> void:
	player_name = ""; # remove all characters in the name

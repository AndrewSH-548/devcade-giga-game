extends Control
class_name WinScene

@onready var placement_title: Label = $Results/PlacementTitle
@onready var leaderboard_title: Label = $Results/LeaderboardTitle
@onready var leaderboard: VBoxContainer = $Results/BoardMargin/Leaderboard
@onready var results: VBoxContainer = $Results
@onready var results_other: Control = $ResultsOther

@onready var name_input: Button = $"Results/Name Input"
@onready var player_name_label: Label = $EnterRecord/NameInputContainer/Panel/PlayerNameLabel
@onready var name_input_container: VBoxContainer = $EnterRecord/NameInputContainer
@onready var name_input_panel: Panel = $EnterRecord
@onready var d_key: Button = $EnterRecord/NameInputContainer/GridContainer/D
@onready var winner_label: Label = $EnterRecord/Winner
@onready var winner_multiplayer: Label = $Results/WinnerMultiplayer

@onready var level_select_button: Button = $"ResultsOther/Level Select"
@onready var quit_button: Button = $ResultsOther/Quit

@onready var placement: Control = $Results/Placement
@onready var top_spacer: HSeparator = $Results/TopSpacer

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
	
	get_tree().get_first_node_in_group("LevelHeader").queue_free()
	
	if not session_info.is_multiplayer:
		
		results.focus_behavior_recursive = Control.FOCUS_BEHAVIOR_DISABLED
		name_input_panel.focus_behavior_recursive = Control.FOCUS_BEHAVIOR_INHERITED
		
		results.hide()
		results_other.hide()
		name_input_panel.show()
		placement.hide()
		
		d_key.grab_focus()
		name_input_panel.show()
	else:
		results.focus_behavior_recursive = Control.FOCUS_BEHAVIOR_INHERITED
		name_input_panel.focus_behavior_recursive = Control.FOCUS_BEHAVIOR_DISABLED
		
		results.alignment = BoxContainer.ALIGNMENT_CENTER
		results_other.position.y += 625
		
		top_spacer.hide()
		results.show()
		results_other.show()
		name_input_panel.hide()
		leaderboard_title.hide()
		leaderboard.hide()
		
		level_select_button.grab_focus()
	
	leaderboard_title.text = "Leaderboard"
	player_name = ""

func save_time_to_leaderboard() -> LevelLeaderboard.SingleRecord:
	if player_name == "":
		return null
	var record: LevelLeaderboard.SingleRecord = TimeManager.save_and_get_current_record(player_name, session_info)
	TimeManager.reset_timer()
	return record

func display_current_leaderboard() -> void:
	var current_leaderboard: LevelLeaderboard = TimeManager.leaderboards[session_info.level_info.name]
	# Setup the first 3 records
	var count: int = 0
	for record: LevelLeaderboard.SingleRecord in current_leaderboard.best_records:
		# Break if the count is more than 3
		count += 1
		if(count > 5):
			break
		# Display the record
		var display: SingleRecordDispay = LevelLeaderboard.SINGLE_RECORD_DISPLAY.instantiate()
		leaderboard.add_child(display)
		display.setup(record, count)

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
	name_input_panel.hide()
	
	results.focus_behavior_recursive = Control.FOCUS_BEHAVIOR_INHERITED
	name_input_panel.focus_behavior_recursive = Control.FOCUS_BEHAVIOR_DISABLED
	
	results.show()
	results_other.show()
	placement.show()
	name_input_panel.hide()
	
	level_select_button.grab_focus()
	
	var current_time: float = TimeManager.current_time_trial_time
	var saved_record: LevelLeaderboard.SingleRecord = save_time_to_leaderboard()
	display_current_leaderboard()
	
	var record: SingleRecordDispay = LevelLeaderboard.SINGLE_RECORD_DISPLAY.instantiate()
	var level_leaderboard: LevelLeaderboard = TimeManager.leaderboards[session_info.level_info.name]
	var placement_number: int = 0
	
	if saved_record == null:
		saved_record = LevelLeaderboard.SingleRecord.new()
		saved_record.player = "You"
		saved_record.character = session_info.characters[0].name
		saved_record.time = current_time
		placement_number = level_leaderboard.get_placement_best_from_time(current_time)
	else:
		placement_number = level_leaderboard.get_placement_best(saved_record)
	
	placement.add_child(record)
	record.setup(saved_record, placement_number)

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

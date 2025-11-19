extends Control

@onready var board_1: LeaderboardTable = $VBoxContainer/Boards/MarginContainer/ScrollContainer/VBoxContainer/Board
@onready var board_2: LeaderboardTable = $VBoxContainer/Boards/MarginContainer/ScrollContainer/VBoxContainer/Board2
@onready var board_3: LeaderboardTable = $VBoxContainer/Boards/MarginContainer/ScrollContainer/VBoxContainer/Board3

@onready var scroll: ScrollContainer = $VBoxContainer/Boards/MarginContainer/ScrollContainer

@onready var back: Button = $VBoxContainer/TopContainer/Back
@onready var up: Button = $VBoxContainer/Boards/Up
@onready var down: Button = $VBoxContainer/Boards/Down

func _ready() -> void:
	board_1.leaderboard = TimeManager.leaderboards["Jungle"]
	board_2.leaderboard = TimeManager.leaderboards["Volcano"]
	board_3.leaderboard = TimeManager.leaderboards["Reef"]
	back.grab_focus()
	update_all()
@onready var volcano_leaderboard: Label = $VBoxContainer/VScrollBar/MarginContainer/TabContainer/Volcano/VolcanoLeaderboard
@onready var jungle_leaderboard: Label = $VBoxContainer/VScrollBar/MarginContainer/TabContainer/Jungle/JungleLeaderboard
@onready var reef_leaderboard: Label = $VBoxContainer/VScrollBar/MarginContainer/TabContainer/Reef/ReefLeaderboard

@onready var tab_container: TabContainer = $VBoxContainer/VScrollBar/MarginContainer/TabContainer
@onready var back: Button = $VBoxContainer/TopContainer/Back
@onready var v_scroll_bar: ScrollContainer = $VBoxContainer/VScrollBar

const SCROLL_SHIFT = 20; ## determines how much the page will scroll for every user input

func _ready() -> void:
	display_leaderboard("volcano");
	display_leaderboard("jungle");
	display_leaderboard("reef")
	back.grab_focus();
	
func _process(_delta: float) -> void:
	if(Input.is_action_pressed("p1_jump") || Input.is_action_pressed("p2_jump")): # allows the user to scroll through the records page
		v_scroll_bar.scroll_vertical -= SCROLL_SHIFT;
	elif(Input.is_action_pressed("p1_crouch") || Input.is_action_pressed("p2_crouch")):
		v_scroll_bar.scroll_vertical += SCROLL_SHIFT;
	if(Input.is_action_just_pressed("p1_right") || Input.is_action_just_pressed("p1_right")):
		next_tab();
	elif(Input.is_action_just_pressed("p1_left") || Input.is_action_just_pressed("p1_left")):
		prev_tab();

func next_tab() -> void: ## go to next tab, wraps to start when currently at the last tab
	if(tab_container.current_tab == tab_container.get_tab_count() - 1):
		tab_container.current_tab = 0;
	else:
		tab_container.current_tab += 1;

func prev_tab() -> void: ## go to previous tab, wraps to end when currently at the first tab
	if(tab_container.current_tab == 0):
		tab_container.current_tab = tab_container.get_tab_count() - 1; # -1 to account for indexing
	else:
		tab_container.current_tab -= 1;

func display_leaderboard(level: String) -> void:
	var player_name = "";
	var leaderboard = volcano_leaderboard;
	match level.to_lower():
		"volcano":
			leaderboard = volcano_leaderboard;
		"jungle":
			leaderboard = jungle_leaderboard;
		"reef":
			leaderboard = reef_leaderboard
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
		leaderboard.text += player_name + " ----- " + str(leaderboard_values[i]) + "s\n";

func update_all():
	board_1.update()
	board_2.update()
	board_3.update()

func load_start_screen() -> void:
	get_tree().change_scene_to_file("res://scenes/start_screen.tscn")
	queue_free()

func _process(delta: float) -> void:
	if up.button_pressed:
		scroll.scroll_vertical -= int(delta * 1000)
	if down.button_pressed:
		scroll.scroll_vertical += int(delta * 1000)

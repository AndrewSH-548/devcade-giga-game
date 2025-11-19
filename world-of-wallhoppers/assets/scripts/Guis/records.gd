extends Control

@onready var scroll: ScrollContainer = $VBoxContainer/Boards/MarginContainer/ScrollContainer

@onready var tab_container: TabContainer = $VBoxContainer/VScrollBar/MarginContainer/TabContainer
@onready var back: Button = $VBoxContainer/TopContainer/Back
@onready var scroll_bar: ScrollContainer = $VBoxContainer/VScrollBar

@onready var volcano_leaderboard: Label = $VBoxContainer/VScrollBar/MarginContainer/TabContainer/Volcano/VolcanoLeaderboard
@onready var jungle_leaderboard: Label = $VBoxContainer/VScrollBar/MarginContainer/TabContainer/Jungle/JungleLeaderboard
@onready var reef_leaderboard: Label = $VBoxContainer/VScrollBar/MarginContainer/TabContainer/Reef/ReefLeaderboard

func _ready() -> void:
	#display_leaderboard("volcano")
	#display_leaderboard("jungle")
	#display_leaderboard("reef")
	back.grab_focus();
	update_all()
	
func _process(_delta: float) -> void:
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

func update_all():
	pass
	#board_1.update()
	#board_2.update()
	#board_3.update()

func load_start_screen() -> void:
	get_tree().change_scene_to_file("res://scenes/start_screen.tscn")
	queue_free()

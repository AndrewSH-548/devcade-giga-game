extends Control
class_name CharacterSelect

@onready var dial: Control = $MainVertical/CharacterWheel/DialPositioner

@onready var ready_all: Control = $ReadyAll
@onready var ready_player_1: Control = $MainVertical/CharacterWheel/ReadyP1
@onready var ready_player_2: Control = $MainVertical/CharacterWheel/ReadyP2

@onready var character_tester_player_1: CharacterTester = $MainVertical/CharacterWheel/CharacterTesterP1
@onready var character_tester_player_2: CharacterTester = $MainVertical/CharacterWheel/CharacterTesterP2

@onready var name_player_1: Label = $MainVertical/CharacterWheel/NameP1
@onready var name_player_2: Label = $MainVertical/CharacterWheel/NameP2

static var player_colors: Array[Color] = [
	Color(1.0, 0.37, 0.37, 1.0),
	Color(0.109, 0.755, 0.547, 1.0),
]

const HEADER_MULTIPLAYER = preload("res://scenes/header_multiplayer.tscn")
const HEADER_SINGLEPLAYER = preload("res://scenes/header_singleplayer.tscn")
var LEVEL_SELECT = load("res://scenes/gui/level_select.tscn")

## -------------- HOW TO ADD A NEW CHARACYER --------------
## 
## 1: Select the Dial Button you wish to use
## 2: Enter your character's name in the Dial Button's variables
## 3: Select your character's PackedScene in the Dial Button's variables
## 4: Anything a child of "Mask" can be changed, and new things can be added
##
## NOTE: DO NOT CHANGE THE DIAL ID! THIS WILL BREAK A LOT OF THINGS!
##
## 5: Under both "TopPortraits" and "BottomPortraits" do these steps:
##    1) Copy+Pase a "PortraitHolder", and set it's variable "ConnectedDial"
##			to the dial spot which your character is on
##    2) Make sure the "Placement" variable corresponds to its placement
##    3) All children of the "PortraitHolder" can be changed, removed or added as you see fit
var session_info: SessionInfo
var current_dial_selection: Array[DIAL]
var ready_players: Array[bool]
var PLAYER_COUNT: int = 2
var is_multiplayer: bool
var was_all_ready_last_frame: bool = false

enum DIAL {
	NONE,
	TOP,
	BOTTOM,
	TOP_RIGHT,
	TOP_LEFT,
	BOTTOM_LEFT,
	BOTTOM_RIGHT,
}

@onready var dials: Dictionary[DIAL, CharacterSelectDialButton] = {
	DIAL.TOP_LEFT: $MainVertical/CharacterWheel/DialPositioner/DialButtonTopLeft,
	DIAL.TOP: $MainVertical/CharacterWheel/DialPositioner/DialButtonTop,
	DIAL.TOP_RIGHT: $MainVertical/CharacterWheel/DialPositioner/DialButtonTopRight,
	DIAL.BOTTOM_RIGHT: $MainVertical/CharacterWheel/DialPositioner/DialButtonBottomRight,
	DIAL.BOTTOM: $MainVertical/CharacterWheel/DialPositioner/DialButtonBottom,
	DIAL.BOTTOM_LEFT: $MainVertical/CharacterWheel/DialPositioner/DialButtonBottomLeft,
}

# Gets either the singleplayer or multiplayer header, depending on mode
func get_level_header() -> MainLevelHeader:
	if session_info.is_multiplayer: return HEADER_MULTIPLAYER.instantiate()
	else: return HEADER_SINGLEPLAYER.instantiate()

func start_game():
	session_info.characters = []
	for index in range(PLAYER_COUNT):
		if index > 0 and not is_multiplayer: break
		if dials.get(index) == null: return
		if dials[current_dial_selection[index]].character_scene == null: return
		session_info.characters.append(dials[current_dial_selection[index]].character_scene)
	
	var header: MainLevelHeader = get_level_header()
	get_tree().root.add_child(header)
	header.setup(session_info)
	queue_free()

func go_back_to_level_select():
	var level_select: LevelSelect = LEVEL_SELECT.instantiate()
	get_tree().root.add_child(level_select)
	level_select.is_multiplayer = is_multiplayer
	queue_free()

func setup(_session_info: SessionInfo) -> void:
	session_info = _session_info
	is_multiplayer = session_info.is_multiplayer
	setup_for_player_count(PLAYER_COUNT)

func _process(_delta: float) -> void:
	ready_button_process()
	player_select_process()
	name_label_process()
	player_tester_process()
	start_game_process()

func name_label_process():
	var dial_p1: CharacterSelectDialButton = dials.get(current_dial_selection[0])
	
	name_player_1.text = dial_p1.character_name if dial_p1 != null else ""
	
	if not is_multiplayer: return
	
	var dial_p2: CharacterSelectDialButton = dials.get(current_dial_selection[1])
	name_player_2.text = dial_p2.character_name if dial_p2 != null else ""

func player_select_process():
	player_selection(0)
	if is_multiplayer:
		player_selection(1)

func start_game_process():
	var is_all_ready: bool = not false in ready_players
	ready_all.visible = is_all_ready
	if is_all_ready and was_all_ready_last_frame and (player_just_pressed("confirm", 0) or player_just_pressed("confirm", 1)):
		start_game()
	was_all_ready_last_frame = is_all_ready

func setup_for_player_count(player_count: int):
	if not is_multiplayer: player_count = 1
	ready_players.resize(player_count)
	current_dial_selection.resize(player_count)
	for index in range(current_dial_selection.size()):
		current_dial_selection[index] = DIAL.TOP
	for dial_button in dials.values():
		dial_button.selected_by.resize(player_count)

func player_ui_input(player_index: int) -> Vector2:
	match player_index:
		0: return Input.get_vector("p1_left", "p1_right", "p1_up", "p1_down")
		1: return Input.get_vector("p2_left", "p2_right", "p2_up", "p2_down")
	assert(false, "Invalid player index used in player_ui_input. Index Entered: " + str(player_index))
	return Vector2.ZERO

func move_destination(player_index: int, left: DIAL, right: DIAL, up: DIAL, down: DIAL):
	if player_just_pressed("left", player_index):
		current_dial_selection[player_index] = left
	if player_just_pressed("right", player_index):
		current_dial_selection[player_index] = right
	if player_just_pressed("up", player_index):
		current_dial_selection[player_index] = up
	if player_just_pressed("down", player_index):
		current_dial_selection[player_index] = down

func player_selection(player_index: int):
	
	if ready_players[player_index] == true:
		if player_just_pressed("cancel", player_index):
			ready_players[player_index] = false
		return
	
	if player_just_pressed("cancel", player_index):
		go_back_to_level_select()
	
	if current_dial_selection[player_index] != DIAL.NONE and player_just_pressed("confirm", player_index):
		ready_players[player_index] = true
	
	# Current is the currently selected dial, TOP, BOTTOM, BOTTOM_LEFT, etc, etc.
	# move_destination is definited by, left, right, up, down
	# So each match tells where each direction leads
	# So for NONE, pressing left->TOP_LEFT, right->TOP_RIGHT, up->TOP, down->BOTTOM
	match current_dial_selection[player_index]:
		#DIAL.NONE: move_destination(player_index, DIAL.TOP_LEFT, DIAL.TOP_RIGHT, DIAL.TOP, DIAL.BOTTOM)
		DIAL.TOP: move_destination(player_index, DIAL.TOP_LEFT, DIAL.TOP_RIGHT, DIAL.TOP, DIAL.BOTTOM)
		DIAL.BOTTOM: move_destination(player_index, DIAL.BOTTOM_RIGHT, DIAL.BOTTOM_LEFT, DIAL.TOP, DIAL.BOTTOM)
		DIAL.TOP_LEFT: move_destination(player_index, DIAL.BOTTOM_LEFT, DIAL.TOP, DIAL.TOP, DIAL.BOTTOM_LEFT)
		DIAL.TOP_RIGHT: move_destination(player_index, DIAL.TOP, DIAL.BOTTOM_RIGHT, DIAL.TOP, DIAL.BOTTOM_RIGHT)
		DIAL.BOTTOM_LEFT: move_destination(player_index, DIAL.BOTTOM, DIAL.TOP_LEFT, DIAL.TOP_LEFT, DIAL.BOTTOM)
		DIAL.BOTTOM_RIGHT: move_destination(player_index, DIAL.TOP_RIGHT, DIAL.BOTTOM, DIAL.TOP_RIGHT, DIAL.BOTTOM)
	
	for dial_button: CharacterSelectDialButton in dials.values():
		dial_button.selected_by[player_index] = dial_button.dial_id == current_dial_selection[player_index]

func ready_button_process():
	ready_player_1.visible = ready_players[0] == true
	if not is_multiplayer: return
	ready_player_2.visible = ready_players[1] == true

static func player_just_pressed(action_name: String, player_index: int):
	
	# Handle Special P1 Cases
	if player_index == 0 and action_name in ["confirm", "cancel"]:
		match action_name:
			"confirm": return Input.is_action_just_pressed("ui_accept")
			"cancel": return Input.is_action_just_pressed("ui_cancel")
	
	return Input.is_action_just_pressed("p" + str(player_index + 1) + "_" + action_name)

func player_tester_process():
	if ready_players[0]:
		if dials[current_dial_selection[0]].character_scene == null:
			ready_players[0] = false
		else:
			character_tester_player_1.start(dials[current_dial_selection[0]].character_scene, 0)
	else:
		character_tester_player_1.stop()
	
	if is_multiplayer and ready_players[1]:
		if dials[current_dial_selection[1]].character_scene == null:
			ready_players[1] = false
		else:
			character_tester_player_2.start(dials[current_dial_selection[1]].character_scene, 1)
	else:
		character_tester_player_2.stop()

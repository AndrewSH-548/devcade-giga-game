extends Control
class_name CharacterSelect

@onready var dial: Control = $MainVertical/CharacterWheel/DialPositioner
@onready var pointer: Sprite2D = $MainVertical/CharacterWheel/DialPositioner/Pointer

static var player_colors: Array[Color] = [
	Color(1.0, 0.37, 0.37, 1.0),
	Color(0.109, 0.755, 0.547, 1.0),
]

const CHARACTER_PORTRAIT = preload("uid://br12fqlynos76")
const HEADER_MULTIPLAYER = preload("uid://ch4mextx4xjgt")
const HEADER_SINGLEPLAYER = preload("uid://c3bkjibfhfofl")

var session_info: SessionInfo
var current_dial_selection: Array[DIAL]
var PLAYER_COUNT: int = 2
var is_multiplayer: bool

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
		session_info.characters.append(dials[current_dial_selection[index]].character_scene)
	
	var header: MainLevelHeader = get_level_header()
	get_tree().root.add_child(header)
	header.setup(session_info)
	queue_free()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("p1_run"):
		start_game()

func setup(_session_info: SessionInfo) -> void:
	session_info = _session_info
	is_multiplayer = session_info.is_multiplayer
	setup_for_player_count(PLAYER_COUNT)

func _process(delta: float) -> void:
	player_selection(0)
	if not is_multiplayer: return
	player_selection(1)

func setup_for_player_count(player_count: int):
	if not is_multiplayer: player_count = 1
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
	if Input.is_action_just_pressed("p" + str(player_index + 1) + "_left"):
		current_dial_selection[player_index] = left
	if Input.is_action_just_pressed("p" + str(player_index + 1) + "_right"):
		current_dial_selection[player_index] = right
	if Input.is_action_just_pressed("p" + str(player_index + 1) + "_up"):
		current_dial_selection[player_index] = up
	if Input.is_action_just_pressed("p" + str(player_index + 1) + "_down"):
		current_dial_selection[player_index] = down

func player_selection(player_index: int):
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

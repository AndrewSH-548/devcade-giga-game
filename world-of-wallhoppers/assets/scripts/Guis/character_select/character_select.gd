extends Control
class_name CharacterSelect

# The big level picture
@onready var level_picture: TextureRect = $MainVertical/PanelLevel/MarginContainer/LevelPicture
# The big portraits of the characters
@onready var player_1_portrait: TextureRect = $MainVertical/Container/HorizontalPlayers/Player1/PanelP1/MarginContainer/Player1Portrait
@onready var player_2_portrait: TextureRect = $MainVertical/Container/HorizontalPlayers/Player2/PanelP2/MarginContainer/Player2Portrait

# The flow control for the buttons
@onready var character_flow: FlowContainer = $MainVertical/ContainerCharacters/CenterContainer/CharacterFlow
# Used for 2-Player selection, change this if the amount of character buttons
# per row changes for some reason. Might change this later to work differently
const CHARACTERS_PER_FLOW_ROW: int = 6

const CHARACTER_BUTTON = preload("uid://chd4b8sjek0pn")

var buttons: Array[CharacterButton] = []
# The currenlt focuesed button for each player
var focus_player_1: CharacterButton = null
var focus_player_2: CharacterButton = null

# Using these to make code easier to read
const PLAYER_1: int = 0
const PLAYER_2: int = 1

# The current entire SessionInfo
var session_info: SessionInfo

func _ready() -> void:
	# Loop through all the DEFINITIONS of all the characters...
	for character in Definitions.characters:
		# Add a button for each character
		var button: CharacterButton = CHARACTER_BUTTON.instantiate()
		# Setup the button, handled internally
		button.setup(character)
		# Add the button to the FLOW CONTROL
		character_flow.add_child(button)
		# Add the button to the buttons array
		buttons.append(button)

func setup(_session_info: SessionInfo) -> void:
	# Get and save the SessionInfo from 
	session_info = _session_info
	# Configure for singleplayer and multiplayer
	focus_player_1 = buttons[0]
	if session_info.is_multiplayer:
		focus_player_2 = buttons[0]

func player_pressed(player_index: int, action: String) -> bool:
	match player_index:
		PLAYER_1: return Input.is_action_just_pressed("p1_" + action)
		PLAYER_2: return Input.is_action_just_pressed("p2_" + action)
	assert(false, "Invalid player index used in player_pressed. Index Entered: " + str(player_index))
	return false

func get_player_focus(player_index: int) -> CharacterButton:
	match player_index:
		PLAYER_1: return focus_player_1
		PLAYER_2: return focus_player_2
	assert(false, "Invalid player index used in get_player_focus. Index Entered: " + str(player_index))
	return null

func player_input_to_neighbor(player_index: int) -> Control:
	if player_pressed(player_index, "up"):
		return get_player_focus(player_index).find_valid_focus_neighbor(SIDE_TOP)
	if player_pressed(player_index, "down"):
		return get_player_focus(player_index).find_valid_focus_neighbor(SIDE_BOTTOM)
	if player_pressed(player_index, "left"):
		return get_player_focus(player_index).find_valid_focus_neighbor(SIDE_LEFT)
	if player_pressed(player_index, "right"):
		return get_player_focus(player_index).find_valid_focus_neighbor(SIDE_RIGHT)
	return null

func _process(_delta: float) -> void:
	process_button_updating()
	process_input()

func process_input() -> void:
	# If the players have pressed a direction, and that leads to a button,
	# move the selection to thet button
	var player_1_move_to: Control = player_input_to_neighbor(PLAYER_1)
	if player_1_move_to is CharacterButton:
		focus_player_1 = player_1_move_to
	# Skip player 2 if not in multiplayer
	if not session_info.is_multiplayer:
		return
	# Handle player 2
	var player_2_move_to: Control = player_input_to_neighbor(PLAYER_2)
	if player_2_move_to is CharacterButton:
		focus_player_2 = player_2_move_to

func process_button_updating() -> void:
	for button in buttons:
		# If the button is focused by a player, set the
		# corresponding "selected" index to true, otherwise false
		button.selected[PLAYER_1] = button == focus_player_1
		button.selected[PLAYER_2] = button == focus_player_2

extends Control
class_name CharacterSelect

# The big level picture
@onready var level_picture: TextureRect = $MainVertical/PanelLevel/MarginContainer/LevelPicture
# The big portraits of the characters
@onready var player_1_portrait: TextureRect = $MainVertical/Container/HorizontalPlayers/Player1/PanelP1/MarginContainer/Player1Portrait
@onready var player_2_portrait: TextureRect = $MainVertical/Container/HorizontalPlayers/Player2/PanelP2/MarginContainer/Player2Portrait

# The flow control for the buttons
@onready var character_flow: FlowContainer = $MainVertical/ContainerCharacters/CenterContainer/CharacterFlow
# The "START?" text that is shown before starting the round
@onready var ready_all: Control = $ReadyAll

# Used for 2-Player selection, change this if the amount of character buttons
# per row changes for some reason. Might change this later to work differently
const CHARACTERS_PER_FLOW_ROW: int = 6

const CHARACTER_BUTTON = preload("res://scenes/gui/character_select/character_button.tscn")

var buttons: Array[CharacterButton] = []
# The current focuesed button for each player
var player_focued: Array[CharacterButton] = []
# The current choice of each player, -1 if not chosen
var player_choices: Array[int] = []

# The amount of players in the current session
var player_count: int = -1

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
	player_count = 1
	if session_info.is_multiplayer:
		player_count = 2
	# Resize the focus array to the amount of players, and focus all to the first button
	player_focued.resize(player_count)
	player_focued.fill(buttons[0])
	# Same for the player_choices array, with no choice as default
	player_choices.resize(player_count)
	player_choices.fill(-1)

func player_pressed(player_index: int, action: String) -> bool:
	# Special Cases for P1 Input
	if action == "confirm" and player_index == PLAYER_1:
		return Input.is_action_just_pressed("ui_accept")
	if action == "cancel" and player_index == PLAYER_1:
		return Input.is_action_just_pressed("ui_cancel")
	# General Case
	if player_index + 1 <= player_count:
		return Input.is_action_just_pressed("p" + str(player_index + 1) + "_" + action)
	# If the index was larger than the player count
	assert(false, "Invalid player index used in player_pressed. Index Entered: " +
		str(player_index) + " (Player #" + str(player_index + 1) + "), Player Count: "
		+ str(player_count))
	return false

func get_player_focus(player_index: int) -> CharacterButton:
	if player_index + 1 <= player_count:
		return player_focued[player_index]
	assert(false, "Invalid player index used in get_player_focus. Index Entered: " +
		str(player_index) + " (Player #" + str(player_index + 1) + "), Player Count: "
		+ str(player_count))
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
	# if ALL players have chosen a character...
	if -1 not in player_choices:
		ready_all.visible = true
		# If any player presses confirm, start the round
		for player_index in range(player_count):
			if player_pressed(player_index, "confirm"):
				# TODO: START ROUND
				pass
		return
	ready_all.visible = false
	
	for player_index in range(player_count):
		# Handle the player as "ready" if they have selected a character
		if player_choices[player_index] != -1:
			handle_ready_player_input(player_index)
			return
		# Otherwise, if they have not selected, handle button selection
		handle_player_selection(player_index)

func handle_player_selection(player_index: int):
	# If the players have pressed a direction, and that leads to a button,
	# move the selection to that button
	var player_move_to: Control = player_input_to_neighbor(player_index)
	if player_move_to is CharacterButton:
		player_focued[player_index] = player_move_to

func handle_ready_player_input(player_index: int):
	# Cancel button selection if the cancel button is pressed
	if player_pressed(player_index, "cancel"):
		player_choices[player_index] = -1

func process_button_updating() -> void:
	for button in buttons:
		# If the button is focused by a player, set the
		# corresponding "selected" index to true, otherwise false
		for player_index in range(player_count):
			button.selected[player_index] = button == player_focued[player_index]

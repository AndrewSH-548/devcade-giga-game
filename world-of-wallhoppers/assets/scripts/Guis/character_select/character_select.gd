extends Control
class_name CharacterSelect

# The big portraits of the characters
@onready var player_1_portrait: TextureRect = $MainVertical/Container/HorizontalPlayers/Player1/PanelP1/MarginContainer/Player1Portrait
@onready var player_2_portrait: TextureRect = $MainVertical/Container/HorizontalPlayers/Player2/PanelP2/MarginContainer/Player2Portrait
# The name labels of the characters
@onready var name_player_1: Label = $MainVertical/Container/HorizontalPlayers/Player1/MarginContainer/NameP1
@onready var name_player_2: Label = $MainVertical/Container/HorizontalPlayers/Player2/MarginContainer/NameP2
# The flow control for the buttons
@onready var character_flow: FlowContainer = $MainVertical/ContainerCharacters/CenterContainer/CharacterFlow
# The "START?" text that is shown before starting the round
@onready var ready_all: Control = $ReadyAll
# The Viewport for the level preview
@onready var level_preview_viewport: SubViewport = $MainVertical/PanelLevel/MarginContainer/LevelPreviewContainer/LevelPreviewViewport
# The level label
@onready var level_name: Label = $MainVertical/NameLevel
# The main container of the player 2 portrait
@onready var player_2_container: VBoxContainer = $MainVertical/Container/HorizontalPlayers/Player2

# Used for 2-Player selection, change this if the amount of character buttons
# per row changes for some reason. Might change this later to work differently
const CHARACTERS_PER_FLOW_ROW: int = 6

const CHARACTER_BUTTON = preload("res://scenes/gui/character_select/character_button.tscn")
const HEADER_MULTIPLAYER = preload("res://scenes/header_multiplayer.tscn")
const HEADER_SINGLEPLAYER = preload("res://scenes/header_singleplayer.tscn")
const MISSING_TEXTURE = preload("res://assets/sprites/missing_texture.png")
const RANDOM_LEVEL_VISUALS = preload("res://scenes/gui/character_select/random_level_visuals.tscn")
@onready var LEVEL_SELECT = load("res://scenes/gui/level_select.tscn")

var buttons: Array[CharacterButton] = []
# The current focuesed button for each player
var player_focused: Array[CharacterButton] = []
# The current choice of each player, null if not chosen
var player_choices: Array[CharacterDefinition] = []
# Holds all player portraits
var player_portraits: Array[TextureRect] = []
# Holds all the player name labels
var player_name_labels: Array[Label] = []

# The amount of players in the current session
var player_count: int = -1

# Using these to make code easier to read
const PLAYER_1: int = 0
const PLAYER_2: int = 1

# The current entire SessionInfo
var session_info: SessionInfo

func _ready() -> void:
	assert(not Definitions.characters.is_empty(), "No characters found in Definitions! Is assets/data/game_definitions.tres corrupted, deleted or changed?")
	# Loop through all the DEFINITIONS of all the characters...
	for character in Definitions.characters:
		# Add a button for each character
		var character_button: CharacterButton = CHARACTER_BUTTON.instantiate()
		# Setup the button, handled internally
		character_button.setup(character)
		# Add the button to the FLOW CONTROL
		character_flow.add_child(character_button)
		# Add the button to the buttons array
		buttons.append(character_button)
	# Add the "random" character
	var button: CharacterButton = CHARACTER_BUTTON.instantiate()
	# Setup the random button, handled internally when null
	button.setup(null)
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
	else:
		# Hid the player 2 portrait and center player 1's name if not in multiplayer
		player_2_container.visible = false
		name_player_1.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	# Resize the focus array to the amount of players, and focus all to the first button
	player_focused.resize(player_count)
	player_focused.fill(buttons[0])
	# Same for the player_choices array, with no choice as default
	player_choices.resize(player_count)
	player_choices.fill(null)
	# Populate the player portaits
	player_portraits = [
		player_1_portrait,
		player_2_portrait,
	]
	# Populate the name labels
	player_name_labels = [
		name_player_1,
		name_player_2,
	]
	# Setup the level preview
	setup_level_preview()

func setup_level_preview() -> void:
	# If a random level was chosen, display the random level visual
	if session_info.is_random_level:
		setup_random_level_preview()
		return
	# Instantiate level and add it so the SubViewport
	var level: Level = session_info.level_info.scene.instantiate()
	level.process_mode = Node.PROCESS_MODE_DISABLED
	level_preview_viewport.add_child(level)
	level.global_position = Vector2(240, 297.0)
	# Get the backgrounds manager
	var backgrounds_manager = get_child_in_group(level, "BackgroundsManager")
	if backgrounds_manager != null:
		backgrounds_manager.thumbnail_mode = true
		backgrounds_manager.process_mode = Node.PROCESS_MODE_ALWAYS

# Imports the "random_level_visuals.tscn" scene instead of an actual level
func setup_random_level_preview() -> void:
	var level: Control = RANDOM_LEVEL_VISUALS.instantiate()
	level_preview_viewport.add_child(level)

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
		return player_focused[player_index]
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
	process_level_display()
	process_input()
	process_portraits()

func start_game():
	# Make new characters array
	session_info.characters = []
	for player_index in range(player_count):
		session_info.characters.append(player_choices[player_index])
	
	# Get either the singleplayer or multiplayer header...
	var header: MainLevelHeader = get_level_header()
	# Load it
	get_tree().root.add_child(header)
	# Pass the level header the session info
	header.setup(session_info)
	# Delete this character select
	queue_free()

func go_back_to_level_select():
	# Load the level select
	var level_select: LevelSelect = LEVEL_SELECT.instantiate()
	# Add it to the tree
	get_tree().root.add_child(level_select)
	# Setup the multiplayer variable
	level_select.is_multiplayer = session_info.is_multiplayer
	# Delete this character select
	queue_free()

func process_portraits() -> void:
	# For each player
	for player_index in range(player_count):
		# Get the selected character definition
		var focused: CharacterButton = player_focused[player_index]
		# Display the character name
		player_name_labels[player_index].text = focused.get_character_name()
		# Get the currenlt hovered character's texture
		var texture: Texture2D = focused.get_character_portrait()
		# If there is NOT a texture, use the MISSING texture
		if texture == null:
			if player_portraits[player_index].texture != MISSING_TEXTURE:
				push_error("No texture found for portrait: \"" + focused.get_character_name() + "\", defaulting to missing texture")
			player_portraits[player_index].texture = MISSING_TEXTURE
		# Otherwise use the provided texture
		else:
			player_portraits[player_index].texture = texture
		# Flip the random texture for player 1, so it's the right way around
		if player_index == PLAYER_1:
			if focused.is_random:
				player_portraits[player_index].flip_h = false
			else:
				player_portraits[player_index].flip_h = true
		

func process_level_display() -> void:
	# Display random if a random level was chosen
	if session_info.is_random_level:
		display_random_level()
		return
	# Display the level name
	level_name.text = session_info.level_info.name

func display_random_level() -> void:
	level_name.text = "Random"

func process_input() -> void:
	# Loop through all players...
	for player_index in range(player_count):
		# Handle the player as "ready" if they have selected a character
		if player_choices[player_index] != null:
			handle_ready_player_input(player_index)
	
	# if ALL players have chosen a character...
	if null not in player_choices:
		ready_all.visible = true
		# If any player presses confirm, start the round
		for player_index in range(player_count):
			if player_pressed(player_index, "confirm"):
				start_game()
		# Skip the rest of the function
		return
	
	# If there ARE players that have NOT selected a character...
	# Hide the "START?" graphic
	ready_all.visible = false
	# Loop through all players...
	for player_index in range(player_count):
		#if they have NOT selected a character, handle button selection
		if player_choices[player_index] == null:
			handle_player_selection(player_index)

func handle_player_selection(player_index: int):
	# If the players have pressed a direction, and that leads to a button,
	# move the selection to that button
	var player_move_to: Control = player_input_to_neighbor(player_index)
	if player_move_to is CharacterButton:
		player_focused[player_index] = player_move_to
	# If the player presed "cancel", go back to the level select
	if player_pressed(player_index, "cancel"):
		go_back_to_level_select()
	# If the player pressed "confirm"...
	if player_pressed(player_index, "confirm"):
		# "Choose" the current selection for that player
		player_choices[player_index] = player_focused[player_index].get_character()

func handle_ready_player_input(player_index: int):
	# Cancel button selection if the cancel button is pressed
	if player_pressed(player_index, "cancel"):
		player_choices[player_index] = null

func process_button_updating() -> void:
	for button in buttons:
		# If the button is focused by a player, set the
		# corresponding "selected" index to true, otherwise false
		for player_index in range(player_count):
			button.selected[player_index] = button == player_focused[player_index]

# Gets either the singleplayer or multiplayer header, depending on mode
func get_level_header() -> MainLevelHeader:
	if session_info.is_multiplayer: return HEADER_MULTIPLAYER.instantiate()
	else: return HEADER_SINGLEPLAYER.instantiate()

# Searches for the first child of the provided node which is also in the provided group
func get_child_in_group(parent: Node, group: StringName) -> Node:
	for node in parent.get_tree().get_nodes_in_group(group):
		if parent.is_ancestor_of(node):
			return node
	return null

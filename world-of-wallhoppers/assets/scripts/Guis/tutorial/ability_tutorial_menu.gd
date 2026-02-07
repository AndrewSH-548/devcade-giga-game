extends Control

const CHARACTER_BUTTON = preload("res://scenes/gui/character_select/character_button.tscn")

@onready var character_flow: FlowContainer = $MainVertical/VBoxContainer/ContainerCharacters/CenterContainer/CharacterFlow
@onready var character_name: Label = $MainVertical/VBoxContainer/CharacterName
@onready var ability_description: RichTextLabel = $MainVertical/VBoxContainer/DescriptionMargin/PanelContainer/TextMargin/AbilityDescription
@onready var showcase_viewport: SubViewport = $MainVertical/VBoxContainer/ShowcaseMargin/ShowcaseContainer/MarginContainer/ViewContainer/ShowcaseViewport
@onready var control_label: RichTextLabel = $MainVertical/VBoxContainer/ShowcaseMargin/ShowcaseContainer/MarginContainer/ControlLabel
@onready var back_button: Button = $MainVertical/Back

const CONTROL_START: String = "Press [color=red]RED[/color] to Control"
const CONTROL_STOP: String = "Press [color=#FFA500]PAUSE[/color] to Stop"

var buttons: Array[CharacterButton] = []
var last_highlight: CharacterDefinition = null
var current_highlight: CharacterDefinition = null
var current_showcase: CharacterShowcaseHandler = null
var last_button: CharacterButton = null

var is_controlling_showcase: bool = false

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
		# Connect button to start_controlling_showcase
		character_button.pressed.connect(start_controlling_showcase)
		# Scale the button by 2
		character_button.custom_minimum_size *= 2
		character_button.portrait_texture.custom_minimum_size = character_button.custom_minimum_size
		character_button.pivot_offset = character_button.custom_minimum_size / 2
		character_button.select_color.pivot_offset = character_button.pivot_offset
	buttons[0].grab_focus()
	current_highlight = buttons[0].character_definition

func start_controlling_showcase() -> void:
	if current_showcase == null:
		return
	get_viewport().gui_release_focus()
	is_controlling_showcase = true
	current_showcase.player_control()

func stop_controlling_showcase() -> void:
	is_controlling_showcase = false
	if last_button != null:
		last_button.grab_focus()
	else:
		back_button.grab_focus()
	if current_showcase != null:
		current_showcase.auto_control()

func _process(_delta: float) -> void:
	process_buttons()
	process_highlight()
	process_showcase_control()

func process_highlight() -> void:
	if last_highlight != current_highlight:
		last_highlight = current_highlight
		setup_showcase(current_highlight)

func setup_showcase(character: CharacterDefinition) -> void:
	for child in showcase_viewport.get_children():
		child.queue_free()
	character_name.text = character.name
	ability_description.text = character.tutorial_ability_description
	if character.tutorial_ability_showcase != null:
		current_showcase = character.tutorial_ability_showcase.instantiate()
		showcase_viewport.add_child(current_showcase)
	else:
		current_showcase = null

func process_showcase_control() -> void:
	if is_controlling_showcase:
		control_label.text = CONTROL_STOP
		if Input.is_action_just_pressed("pause"):
			stop_controlling_showcase()
	else:
		control_label.text = CONTROL_START

func process_buttons() -> void:
	control_label.visible = false
	control_label.modulate.a = sin(Time.get_ticks_msec() / 500.0) * 0.20 + 0.40
	if is_controlling_showcase:
		control_label.visible = true
	for button in buttons:
		if button == get_viewport().gui_get_focus_owner():
			last_button = button
			if current_showcase != null:
				control_label.visible = true
			current_highlight = button.character_definition
			button.selected[0] = true
			button.selected[1] = true
		else:
			button.selected[0] = false
			button.selected[1] = false

func go_to_tutorial_menu() -> void:
	get_tree().change_scene_to_file("res://scenes/gui/tutorial/tutorial_menu.tscn")
	queue_free()

extends Control
class_name CharacterSelect

@export var characters: Array[CharacterDefinition]

@onready var level_picture: TextureRect = $MainVertical/PanelLevel/MarginContainer/LevelPicture
@onready var player_1_portrait: TextureRect = $MainVertical/Container/HorizontalPlayers/Player1/PanelP1/MarginContainer/Player1Portrait
@onready var player_2_portrait: TextureRect = $MainVertical/Container/HorizontalPlayers/Player2/PanelP2/MarginContainer/Player2Portrait

@onready var character_flow: FlowContainer = $MainVertical/ContainerCharacters/CenterContainer/CharacterFlow

const CHARACTERS_PER_FLOW_ROW: int = 6

var focus_player_1: int = 0
var focus_player_2: int = 0

func _ready() -> void:
	# Loop through all the DEFINITIONS of all the characters
	for character in characters:
		var button: CharacterButton = CharacterButton.new()
		button.setup(character)
		character_flow.add_child(button)

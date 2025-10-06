extends Node2D
class_name PortraitHolder

@onready var character_select: CharacterSelect = get_tree().get_first_node_in_group("CharacterSelect")

enum PLACEMENT {
	TOP,
	BOTTOM,
}

@export var placement: PLACEMENT
@export var connected_dial: CharacterSelect.DIAL

var connected_player_index: int

func _ready() -> void:
	connected_player_index = 0 if placement == PLACEMENT.TOP else 1
	assert(character_select != null, "Character select not found for a portrait holder! Is the character select not in the \"CharacterSelect\" group?")

func _process(delta: float) -> void:
	if not character_select.is_multiplayer and connected_player_index != 0:
		visible = false
		return
	if character_select.current_dial_selection[connected_player_index] == connected_dial:
		visible = true
	else:
		visible = false

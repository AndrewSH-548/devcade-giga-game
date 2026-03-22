extends Node2D
class_name Testroom

@export var player_1s: Array[Player]
@export var player_2s: Array[Player]
@onready var camera: Camera2D = $Camera

@onready var player_spawn: Marker2D = $PlayerSpawn

func _ready() -> void:
	for player in player_1s: player.setup_keybinds(1)
	for player in player_2s: player.setup_keybinds(2)
	add_dummy_events()
	dummyify_players(self)

func setup_custom(session: SessionInfo) -> void:
	add_player(session.characters[0], player_1s)
	if session.is_multiplayer:
		add_player(session.characters[1], player_2s)

func add_player(character: CharacterDefinition, player_array: Array[Player], at_end: bool = false) -> Player:
	var player: Player = character.scene.instantiate()
	add_child(player)
	if not at_end:
		player_array.push_front(player)
	else:
		player_array.append(player)
	player.global_position = player_spawn.global_position
	
	match player_array:
		player_1s: player.setup_keybinds(1)
		player_2s: player.setup_keybinds(2)
	
	return player

func dummyify_players(parent: Node) -> void:
	var children: Array[Node] = parent.get_children()
	if children.size() == 0: return
	for child in children:
		if child is Player:
			if child not in player_1s and child not in player_2s:
				child.setup_keybinds(0)
		dummyify_players(child)

func _process(_delta: float) -> void:
	camera.global_position = player_1s[0].global_position

var used_events: Array[String] = [
	"left",
	"right",
	"jump",
	"run",
	"crouch",
]

func add_dummy_events() -> void:
	for event in used_events:
		if not InputMap.has_action("p0_" + event):
			InputMap.add_action("p0_" + event)

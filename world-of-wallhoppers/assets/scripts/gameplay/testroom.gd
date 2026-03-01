extends Node2D

@export var player_1s: Array[Player]
@export var player_2s: Array[Player]
@onready var camera: Camera2D = $Camera

func _ready() -> void:
	for player in player_1s: player.setup_keybinds(1)
	for player in player_2s: player.setup_keybinds(2)
	add_dummy_events()
	dummyify_players(self)

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

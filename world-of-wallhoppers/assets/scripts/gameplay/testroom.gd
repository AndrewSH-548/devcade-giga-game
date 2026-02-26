extends Node2D

@export var player_1s: Array[Player]
@export var player_2s: Array[Player]
@onready var camera: Camera2D = $Camera

func _ready() -> void:
	for player in player_1s: player.setup_keybinds(1)
	for player in player_2s: player.setup_keybinds(2)

func _process(_delta: float) -> void:
	camera.global_position = player_1s[0].global_position

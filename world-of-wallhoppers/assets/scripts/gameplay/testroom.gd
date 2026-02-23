extends Node2D

@export var player: Player
@export var player_2: Player
@onready var camera: Camera2D = $Camera

func _ready() -> void:
	player.setup_keybinds(1)
	player_2.setup_keybinds(2)

func _process(delta: float) -> void:
	camera.global_position = player.global_position

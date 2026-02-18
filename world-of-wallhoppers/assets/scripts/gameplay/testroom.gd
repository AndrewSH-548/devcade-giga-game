extends Node2D

@export var player: Player

func _ready() -> void:
	player.setup_keybinds(1);

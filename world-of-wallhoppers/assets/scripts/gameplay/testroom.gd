extends Node2D

@onready var player:Player = $PlayerHip

func _ready() -> void:
	player.setup_keybinds(1);

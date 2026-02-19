extends Node2D
class_name Level

@onready var player_spawn_1: Marker2D = $PlayerSpawn1
@onready var player_spawn_2: Marker2D = $PlayerSpawn2

@onready var level_center: Marker2D = $LevelCenter

func _ready() -> void:
	assert(level_center != null, "Level does not have a \"Level Center\" Marker2D node as a direct child! This is required for every level")
	assert(player_spawn_1 != null, "Level could not find Player 1's Spawn!\nMake sure there is a Node2D named \"PlayerSpawn1\" which is a direct child of the level!")
	assert(player_spawn_1 != null, "Level could not find Player 2's Spawn!\nMake sure there is a Node2D named \"PlayerSpawn2\" which is a direct child of the level!")
	
	

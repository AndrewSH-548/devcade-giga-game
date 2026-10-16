extends Resource
class_name LevelDefinition
## Holds readonly information about a specific level. This is set in the "game_definitions.tres" file

## The scene file of the level, the root node should be inherit "level.gd"
@export var scene: PackedScene
## The in-game name of the level
@export var name: String
## The color of the outer "border" of the level, only seen in singleplayer.
## This should generally be simmilar to the ground color of the level
@export var border_color: Color = Color.MAGENTA

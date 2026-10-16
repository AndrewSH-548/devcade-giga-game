class_name CharacterDefinition
extends Resource
## Holds readonly information about a specific character. This is set in the "game_definitions.tres" file

## The character's scene file
@export var scene: PackedScene
## The character's in-game name
@export var name: String
## The texture used for the character's button on the character select screen
@export var button_texture: Texture2D
## The texture used for the character's portrait when selected on the character select screen
@export var portrait_texture: Texture2D
## The pallets used for the character in multiplayer
@export var pallets: PalletSwap
@export_group("Tutorial", "tutorial_")
## A short description of how the character's ability works
@export_multiline var tutorial_ability_description: String
## The scene containing the self-playing scene showcasing the character's ability
## These are implemented using the "showcase_handler.gd" script
@export var tutorial_ability_showcase: PackedScene
## Only used internally to allow choosing a "random" character
var is_random: bool = false

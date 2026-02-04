class_name CharacterDefinition
extends Resource

@export var scene: PackedScene
@export var name: String
@export var button_texture: Texture2D
@export var portrait_texture: Texture2D
# Only used internally to allow choosing a "random" character
var is_random: bool = false

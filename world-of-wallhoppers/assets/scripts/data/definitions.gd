extends Node
class_name Definitions
## Allows access to all "Definitions" setup in the "game_definitions.tres" file

## Readonly definitions for every playable character in the game
static var characters: Array[CharacterDefinition]
## Readonly definitions for every level in the game
static var levels: Array[LevelDefinition]

## Holds the "Game Definition" object containing readonly information about all the characters
## and levels
const DEFINITIONS: GameDefinition = preload("res://assets/data/game_definitions.tres")

## Called on startup, loads all character definitions and level definitions
## from the game_definitions.tres file, into the "characters" and "levels" variables
static func load_definitions() -> void:
	var defs: GameDefinition = DEFINITIONS
	characters = defs.characters as Array[CharacterDefinition]
	levels = defs.levels as Array[LevelDefinition]

## Verifies the there are not duplicate character and level names,
## as this would cause issues with get_character and get_level
static func verify_definition_integrity() -> void:
	var character_names: Array[String] = []
	for character in characters:
		var formatted: String = character.name.strip_edges().to_lower()
		assert(formatted not in character_names, "There can only be one character of name: \"" + formatted + "\" but multiple were defined")
		character_names.append(character.name)
	var level_names: Array[String] = []
	for level in levels:
		var formatted: String = level.name.strip_edges().to_lower()
		assert(formatted not in level_names, "There can only be one level of name: \"" + formatted + "\" but multiple were defined")
		level_names.append(level.name)

## Returns a CharacterDefinition from the character's name, case insensitive
static func get_character(character_name: String) -> CharacterDefinition:
	for character in characters:
		if character.name.strip_edges().to_lower() == character_name.strip_edges().to_lower():
			return character
	assert(false, "Character with name: \"" + character_name + "\" was not found in Definitions")
	return null

## Returns a LevelDefinition from the level's name, case insensitive
static func get_level(level_name: String) -> LevelDefinition:
	for level in levels:
		if level.name.strip_edges().to_lower() == level_name.strip_edges().to_lower():
			return level
	assert(false, "Level with name: \"" + level_name + "\" was not found in Definitions")
	return null

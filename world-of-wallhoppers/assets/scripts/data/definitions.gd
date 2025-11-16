extends Node
class_name Definitions

static var characters: Array[CharacterDef]
static var levels: Array[LevelDef]

# ---=== Put the definitions here ===---
static func define():
	# --------- LEVELS ---------
	add_level("Jungle", preload("res://scenes/levels/jungle.tscn"), Color(0.43529412, 0.23921569, 0, 1))
	add_level("Volcano", preload("res://scenes/levels/volcano.tscn"), Color(0.12941177, 0.011764706, 0.06666667, 1))
	add_level("Reef", preload("res://scenes/levels/reef.tscn"), Color(0, 0.0627451, 0.33333334, 1))
	# --------- CHARACTERS ---------
	add_character("Hip", preload("res://scenes/characters/hip.tscn"))
	add_character("Reign", preload("res://scenes/characters/reign.tscn"))
	add_character("Scoria", preload("res://scenes/characters/scoria.tscn"))

static func add_character(character_name: StringName, character_scene: PackedScene):
	var def: CharacterDef = CharacterDef.new()
	def.name = character_name
	def.scene = character_scene
	characters.append(def)

static func add_level(level_name: StringName, level_scene: PackedScene, level_border_color: Color):
	var def: LevelDef = LevelDef.new()
	def.name = level_name
	def.scene = level_scene
	def.border_color = level_border_color
	levels.append(def)
	#TimeManager.leaderboards[def.name] = LevelLeaderboard.new()

static func get_character(character_name: StringName) -> CharacterDef:
	for character in characters:
		if character.name == character_name:
			return character
	assert(false, "Character with name: \"" + character_name + "\" was not found in Definitions")
	return null

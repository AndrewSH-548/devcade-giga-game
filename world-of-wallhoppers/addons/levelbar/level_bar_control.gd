@tool
class_name PluginLevelBar
extends HBoxContainer

@onready var player_1: OptionButton = $Player1
@onready var player_2: OptionButton = $Player2
@onready var level: OptionButton = $Level
@onready var run: Button = $Run

var NONE: Texture2D = load("res://addons/levelbar/none.png")

var characters: Dictionary[int, CharacterDefinition] = { }
var levels: Dictionary[int, LevelDefinition] = { }

var character_indices: Dictionary[StringName, int] = { }
var level_indices: Dictionary[StringName, int] = { }

var plugin

const DevStartupConfig = preload("res://assets/scripts/editor/dev_startup_config.gd")
const SessionInfo = preload("res://assets/scripts/Guis/session_info.gd")

func _ready() -> void:
	player_1.clear()
	player_2.clear()
	level.clear()
	
	var defs: GameDefinition = ResourceLoader.load("res://assets/data/game_definitions.tres")
	
	var character_id: int = 0
	player_2.add_icon_item(setup_texture(NONE), "", character_id)
	character_indices.set(&"None", character_id)
	for character: CharacterDefinition in defs.characters:
		character_id += 1
		var texture: ImageTexture = setup_texture(character.button_texture)
		player_1.add_icon_item(texture, "", character_id)
		player_2.add_icon_item(texture, "", character_id)
		characters.set(character_id, character)
		character_indices.set(character.name, character_id)
	
	var level_id: int = 0
	level.add_item("Testroom", level_id)
	level_indices.set(&"Testroom", level_id)
	for level_def: LevelDefinition in defs.levels:
		level_id += 1
		level.add_item(level_def.name, level_id)
		levels.set(level_id, level_def)
		level_indices.set(level_def.name, level_id)
	
	run.pressed.connect(start)

func setup_texture(texture: Texture2D) -> ImageTexture:
	var image: Image = texture.get_image()
	image.resize(24, 24)
	return ImageTexture.create_from_image(image)

func start() -> void:
	var config: DevStartupConfig = DevStartupConfig.new()
	var session: SessionInfo = SessionInfo.new()
	
	session.characters = []
	
	var player_1_character: CharacterDefinition = characters[player_1.get_selected_id()]
	session.characters.append(player_1_character)
	
	if player_2.get_selected_id() != 0:
		session.is_multiplayer = true
		session.characters.append(characters[player_2.get_selected_id()])
	
	if level.get_selected_id() != 0:
		session.level_info = levels[level.get_selected_id()]
	else:
		config.testroom = true
	
	plugin.start_level(config, session)

func set_player(character_name: StringName, player_number: int) -> void:
	var option: OptionButton
	
	match player_number:
		1: option = player_1
		2: option = player_2
		_: assert(false, "Player Number is not valid!")
	
	if player_number != 1 and character_name == &"None":
		option.select(0)
		return
	
	option.select(option.get_item_index(character_indices[character_name]))

func set_level(level_name: StringName) -> void:
	level.select(level.get_item_index(level_indices[level_name]))

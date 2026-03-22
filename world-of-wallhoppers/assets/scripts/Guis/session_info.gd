extends Resource
class_name SessionInfo

# Used to pass the SessionInfo to the win scene
static var pass_along: SessionInfo = null

@export var is_multiplayer: bool
@export var is_random_level: bool = false
@export var level_info: LevelDefinition
@export var characters: Array[CharacterDefinition]
@export var winner: int = -1

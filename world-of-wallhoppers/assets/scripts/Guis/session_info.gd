extends RefCounted
class_name SessionInfo

# Used to pass the SessionInfo to the win scene
static var pass_along: SessionInfo = null

var is_multiplayer: bool
var level_info: LevelDefinition
var characters: Array[CharacterDefinition]
var winner: int = -1

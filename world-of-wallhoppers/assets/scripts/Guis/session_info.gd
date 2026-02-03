extends RefCounted
class_name SessionInfo

static var pass_along: SessionInfo = null

var is_multiplayer: bool
var level_info: LevelDef
var characters: Array[CharacterDef]
var winner: int = -1

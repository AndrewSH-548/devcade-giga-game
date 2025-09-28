extends MainLevelHeader

var viewportP1
var viewportP2
var staticCamera
var cameraP1
var cameraP2
var levelScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	viewportP1 = $HBoxContainer/ViewportContainerP1/SubViewport
	viewportP2 = $HBoxContainer/ViewportContainerP2/SubViewport
	
	viewportP2.world_2d = viewportP1.world_2d
	
	Engine.time_scale = 1
	pass # Replace with function body.

func setup(session_info: SessionInfo):
	var parent_node: Node = $HBoxContainer/ViewportContainerP1/SubViewport
	
	var level: Node2D = session_info.level.instantiate()
	place_level(level, parent_node)
	level = level as Level
	
	var players: Array[Node2D]
	
	for character in session_info.characters:
		assert(character != null, "The Level Header was loaded with a null Character!\nThis likely means a Character Select Dial was setup incorrectly!")
		var player: Character = character.instantiate()
		
		players.append(player)
		parent_node.add_child(player)
		
		var player_number: int = players.size()
		
		player.add_to_group("player" + str(player_number))
		player.setup_keybinds(player_number)
		
		assert(player_number <= 2, "There currently cannot be more than 2 players, but the players array is larger than 2!\nIf this has changed, please remove this asser() statement!")
	
	players[0].global_position = level.player_spawn_1.global_position
	players[1].global_position = level.player_spawn_2.global_position
	
	get_tree().get_first_node_in_group("Player1Camera").target = players[0]
	get_tree().get_first_node_in_group("Player2Camera").target = players[1]

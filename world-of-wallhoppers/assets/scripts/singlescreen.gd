extends MainLevelHeader

func setup(session_info: SessionInfo) -> void:
	var parent_node: Node = $ViewportContainerP1/SubViewport
	
	var level: Node2D = session_info.level.instantiate()
	place_level(level, parent_node)
	level = level as Level
	
	assert(session_info.characters[0] != null, "The Level Header was loaded with a null Character!\nThis likely means a Character Select Dial was setup incorrectly!")
	
	var character: Character = session_info.characters[0].instantiate()
	parent_node.add_child(character)
	character.add_to_group("player1")
	character.setup_keybinds(1)
	
	get_tree().get_first_node_in_group("Player1Camera").target = character
	
	character.global_position = level.player_spawn_1.global_position

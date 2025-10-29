extends MainLevelHeader

@onready var singleplayer_timer_label: Label = $SingleplayerTimerLabel
@onready var singleplayer_timer: Timer = $SingleplayerTimer

func setup(session_info: SessionInfo) -> void:
	TimeManager.temporary_singleplayer_time = 0; # reset the singleplayer timer
	
	current_session_info = session_info
	var parent_node: Node = $ViewportContainerP1/SubViewport
	
	var level: Node2D = session_info.level_info.scene.instantiate()
	place_level(level, parent_node)
	level = level as Level
	
	assert(session_info.characters[0] != null, "The Level Header was loaded with a null Character!\nThis likely means a Character Select Dial was setup incorrectly!")
	
	var character: Player = session_info.characters[0].instantiate()
	parent_node.add_child(character)
	character.add_to_group("player1")
	character.setup_keybinds(1)
	
	get_tree().get_first_node_in_group("Player1Camera").target = character
	
	$BorderLeft.color = session_info.level_info.border_color
	$BorderRight.color = session_info.level_info.border_color
	
	character.global_position = level.player_spawn_1.global_position

func _on_singleplayer_timer_timeout() -> void:
	TimeManager.increase_temporary_singleplayer_time(0.1);
	singleplayer_timer_label.text = str(TimeManager.temporary_singleplayer_time);

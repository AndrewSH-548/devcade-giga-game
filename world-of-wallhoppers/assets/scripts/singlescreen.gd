extends MainLevelHeader

@onready var singleplayer_timer_label: Label = $ViewportContainerP1/SubViewport/Camera2D/SingleplayerTimerLabel
@onready var singleplayer_timer: Timer = $SingleplayerTimer

var singleplayer_time: float = 0;

func setup(session_info: SessionInfo) -> void:
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
	singleplayer_time += 1;
	singleplayer_timer_label.text = str(singleplayer_time/10);

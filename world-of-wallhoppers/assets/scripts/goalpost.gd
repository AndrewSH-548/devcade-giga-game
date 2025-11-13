extends Node2D

@onready var goal_1: Area2D = $Goal1


## When one of the player(s) hits the goal, the game should end. [br]
## This function handles the emitition of the signal of that [br]
## parameter [b]player_number[/b]: the player number that hit/entered a goal area
func _on_goal_1_body_entered(body: Node2D) -> void:
	if body.is_in_group("player1"): # player 1 (node type doesn't matter, just has to be in group player 1)
		print("RUNNING")
		end_game(1)
	if body.is_in_group("player2"): # player2 (node type doesn't matter, just has to be in group player 2)
		end_game(2)

func end_game(player_number: int) -> void:
	var level_header: MainLevelHeader = get_tree().get_first_node_in_group("splitscreen") as MainLevelHeader
	var session_info: SessionInfo = level_header.current_session_info
	session_info.winner = player_number
	var win_screen: WinScene = preload("res://scenes/win_scene.tscn").instantiate()
	get_tree().root.add_child(win_screen)
	win_screen.session_info = session_info
	level_header.queue_free()

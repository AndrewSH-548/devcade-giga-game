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
	var level_header: LevelHeaderBase = get_tree().get_first_node_in_group("LevelHeader") as LevelHeaderBase
	var session_info: SessionInfo = level_header.current_session_info
	SessionInfo.pass_along = session_info
	session_info.winner = player_number
	get_tree().change_scene_to_file("res://scenes/win_scene.tscn")

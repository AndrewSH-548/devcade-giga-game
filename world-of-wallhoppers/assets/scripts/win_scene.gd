extends Control

func _ready() -> void:
	$"VBoxContainer/Level Select".grab_focus();

func _on_level_select_pressed() -> void:
	var level_select: Control =  MenuStartScreen.LEVEL_SELECT.instantiate()
	level_select.is_multiplayer = get_tree().get_first_node_in_group("splitscreen").current_session_info.is_multiplayer
	get_tree().root.add_child(level_select)
	get_tree().get_first_node_in_group("splitscreen").queue_free()
	queue_free()

func _on_quit_pressed() -> void:
	get_tree().quit(); 

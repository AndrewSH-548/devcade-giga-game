extends Control

@onready var time_label: Label = $VBoxContainer/TimeLabel

func _ready() -> void:
	$"VBoxContainer/Level Select".grab_focus();
	time_label.text = "Completion Time: " + str(TimeManager.return_and_reset_temporary_singleplayer_time());

func _on_level_select_pressed() -> void:
	var level_select: Control =  MenuStartScreen.LEVEL_SELECT.instantiate()
	level_select.is_multiplayer = get_tree().get_first_node_in_group("splitscreen").current_session_info.is_multiplayer
	get_tree().root.add_child(level_select)
	get_tree().get_first_node_in_group("splitscreen").queue_free()
	queue_free()

func _on_quit_pressed() -> void:
	get_tree().quit(); 

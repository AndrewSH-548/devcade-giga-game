extends Control

func _ready() -> void:
	$"VBoxContainer/Level Select".grab_focus();

func _on_level_select_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level_select.tscn");

func _on_quit_pressed() -> void:
	get_tree().quit(); 

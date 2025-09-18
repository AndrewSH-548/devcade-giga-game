extends Control

@onready var main = $"../";

func _on_resume_pressed() -> void:
	main.set_pause(false)

func _on_quit_pressed() -> void:
	Engine.time_scale = 1
	get_tree().change_scene_to_file("res://scenes/start_screen.tscn")
	get_tree().get_first_node_in_group("splitscreen").queue_free()

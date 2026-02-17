extends Control

@onready var main = $"../";

func set_pause(is_paused: bool):
	main.paused = is_paused
	if main.paused:
		show(); 
		get_node('CenterContainer/VBoxContainer/Resume').grab_focus(); 
		Engine.time_scale = 0;
	else:
		hide();
		Engine.time_scale = 1;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		# Toggle pause menu
		set_pause(not main.paused)

func _on_resume_pressed() -> void:
	set_pause(false)

func _on_quit_pressed() -> void:
	Engine.time_scale = 1
	var splitscreen_node = get_parent().get_tree().get_first_node_in_group("splitscreen");
	if (splitscreen_node != null):
		splitscreen_node.queue_free();
	get_tree().change_scene_to_file("res://scenes/start_screen.tscn")
	

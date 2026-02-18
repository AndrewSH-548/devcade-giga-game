extends Control

@onready var main = $"../";
@onready var button_restart: Button = $CenterContainer/VBoxContainer/Restart

var level_header: LevelHeaderBase

func set_pause(is_paused: bool):
	main.paused = is_paused
	if main.paused:
		show()
		get_node('CenterContainer/VBoxContainer/Resume').grab_focus();
		Engine.time_scale = 0
	else:
		hide()
		Engine.time_scale = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		# Toggle pause menu
		set_pause(not main.paused)

func _on_resume_pressed() -> void:
	set_pause(false)

func _on_quit_pressed() -> void:
	Engine.time_scale = 1
	if (level_header != null):
		level_header.queue_free()
	get_tree().change_scene_to_file("res://scenes/start_screen.tscn")

func _on_restart_pressed() -> void:
	set_pause(false)
	if level_header != null:
		level_header.restart()

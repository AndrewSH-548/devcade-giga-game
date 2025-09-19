extends Node2D
class_name MainLevelHeader

@onready var pause_menu = $PauseMenu;
var paused: bool = false;

func place_level(level: Node2D) -> void:
	# This should be overidden in child classses! (Singlescreen, Splitscreen)
	pass

func set_pause(is_paused: bool):
	paused = is_paused
	if paused:
		pause_menu.show(); 
		$PauseMenu/MarginContainer/VBoxContainer/Resume.grab_focus(); 
		Engine.time_scale = 0;
	else:
		pause_menu.hide();
		Engine.time_scale = 1;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		# Toggle pause menu
		set_pause(not paused)

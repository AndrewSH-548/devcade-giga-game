extends Node2D

@onready var pause_menu = $PauseMenu;
var paused: bool = false;

@onready var player_1_body: CharacterBody2D = $ViewportContainerP1/SubViewport/Player1Body

func _ready() -> void:
	player_1_body.add_to_group("player1")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		pauseMenu(); 

func pauseMenu():
	if paused:
		pause_menu.hide();
		Engine.time_scale = 1;
	else:
		pause_menu.show(); 
		$PauseMenu/MarginContainer/VBoxContainer/Resume.grab_focus(); 
		Engine.time_scale = 0;
	
	paused = not paused; 

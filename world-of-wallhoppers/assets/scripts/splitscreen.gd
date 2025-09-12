extends Node2D

var viewportP1;
var viewportP2;
var staticCamera;
var cameraP1;
var cameraP2;
var levelScene;
@onready var pause_menu = $PauseMenu;
var paused: bool = false;

@onready var player_1_body: CharacterBody2D = $HBoxContainer/ViewportContainerP1/SubViewport/Player1Body
@onready var player_2_body: CharacterBody2D = $HBoxContainer/ViewportContainerP1/SubViewport/Player2Body

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	viewportP1 = $HBoxContainer/ViewportContainerP1/SubViewport;
	viewportP2 = $HBoxContainer/ViewportContainerP2/SubViewport;
	
	player_1_body.add_to_group("player1")
	player_2_body.add_to_group("player2")
	
	viewportP2.world_2d = viewportP1.world_2d
	
	Engine.time_scale = 1;
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		pauseMenu(); 

# Handles pausing 
func pauseMenu():
	if paused:
		pause_menu.hide();
		Engine.time_scale = 1;
	else:
		pause_menu.show(); 
		$PauseMenu/MarginContainer/VBoxContainer/Resume.grab_focus(); 
		Engine.time_scale = 0;
	
	paused = not paused; 

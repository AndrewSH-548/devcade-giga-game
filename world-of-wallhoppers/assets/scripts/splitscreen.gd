extends MainLevelHeader

var viewportP1
var viewportP2
var staticCamera
var cameraP1
var cameraP2
var levelScene

@onready var player_1_body: CharacterBody2D = $HBoxContainer/ViewportContainerP1/SubViewport/Player1Body
@onready var player_2_body: CharacterBody2D = $HBoxContainer/ViewportContainerP1/SubViewport/Player2Body

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	viewportP1 = $HBoxContainer/ViewportContainerP1/SubViewport
	viewportP2 = $HBoxContainer/ViewportContainerP2/SubViewport
	
	player_1_body.add_to_group("player1")
	player_2_body.add_to_group("player2")
	
	viewportP2.world_2d = viewportP1.world_2d
	
	Engine.time_scale = 1
	pass # Replace with function body.

func place_level(level: Node2D):
	$HBoxContainer/ViewportContainerP1/SubViewport.add_child(level)

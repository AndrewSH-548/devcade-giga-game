extends MainLevelHeader

@onready var player_1_body: CharacterBody2D = $ViewportContainerP1/SubViewport/Player1Body

func _ready() -> void:
	player_1_body.add_to_group("player1");
	

func place_level(level: Node2D) -> void:
	$ViewportContainerP1/SubViewport.add_child(level)
	

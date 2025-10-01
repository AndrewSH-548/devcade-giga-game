extends MainLevelHeader

@onready var player_1_body: CharacterBody2D = $ViewportContainerP1/SubViewport/Player1Body
@onready var timer_label: Label = $ViewportContainerP1/SubViewport/Camera2D/TimerLabel
@onready var singleplayer_timer: Timer = $ViewportContainerP1/SubViewport/SingleplayerTimer

var singleplayer_time: float = 0;

func _ready() -> void:
	player_1_body.add_to_group("player1");
	

func place_level(level: Node2D) -> void:
	$ViewportContainerP1/SubViewport.add_child(level)
	


func _on_singleplayer_timer_timeout() -> void:
	singleplayer_time += 1;
	timer_label.text = str(singleplayer_time/10);

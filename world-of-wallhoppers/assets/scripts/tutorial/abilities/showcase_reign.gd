extends CharacterShowcaseHandler

@onready var player_reign: PlayerReign = $PlayerReign

func _ready() -> void:
	setup(player_reign, 6.0)

func do_actions() -> void:
	player_reign.position = Vector2(69, 118)
	timer(0.5).connect(func():
		player_reign.isFacingRight = true
		press("jump"))
	timer(1.0).connect(func():
		hold("run")) 
	timer(1.5).connect(func():
		hold("right"))
	timer(2.7).connect(func():
		release("right")
		release("run"))
	timer(3.8).connect(func():
		press("jump"))
	timer(4.3).connect(func():
		hold("run")
		hold("left"))
	timer(5.5).connect(func():
		release("run")
		release("left")
		press("right"))

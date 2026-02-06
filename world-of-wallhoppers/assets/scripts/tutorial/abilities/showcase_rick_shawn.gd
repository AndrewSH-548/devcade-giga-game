extends CharacterShowcaseHandler

@onready var player_rick_shawn: PlayerRickShawn = $PlayerRickShawn

func _ready() -> void:
	setup(player_rick_shawn, 7.0)

func do_actions() -> void:
	player_rick_shawn.position = Vector2(63, 172)
	player_rick_shawn.is_facing_right = true
	timer(0.5).connect(func():
		hold("right")
		press("jump")
	)
	timer(0.7).connect(func():
		hold("run"))
	timer(2.0).connect(func():
		release("run"))
	timer(2.5).connect(func():
		release("right"))
	timer(3.0).connect(func():
		press("jump"))
	timer(3.3).connect(func():
		hold("right"))
	timer(3.6).connect(func():
		release("right")
		hold("left")
		press("jump"))
	timer(4.4).connect(func():
		press("jump"))
	timer(5.0).connect(func():
		hold("run"))
	timer(6.4).connect(func():
		release("left")
		release("run"))
	

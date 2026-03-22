extends CharacterShowcaseHandler

@onready var player_rick_shawn: PlayerRickShawn = $PlayerRickShawn

func _ready() -> void:
	setup(player_rick_shawn, 6.0)

func do_actions() -> void:
	player_rick_shawn.position = Vector2(88, 172)
	player_rick_shawn.is_facing_right = true
	player_rick_shawn.enter_platform_state()
	player_rick_shawn.hitstun = false
	player_rick_shawn.invincibility_timer.stop()
	timer(0.5).connect(func():
		hold("right")
		press("jump"))
	timer(0.7).connect(func():
		press("run")
		release("right"))
	timer(1.7).connect(func():
		hold("left"))
	timer(1.75).connect(func():
		release("left"))
	timer(2.7).connect(func():
		hold("right"))
	timer(3.0).connect(func():
		press("jump"))
	timer(3.6).connect(func():
		release("right")
		hold("left")
		press("jump"))
	timer(3.7).connect(func():
		press("run"))
	timer(4.3).connect(func():
		press("jump"))
	timer(4.5).connect(func():
		release("left"))

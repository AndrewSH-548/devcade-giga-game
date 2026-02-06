extends CharacterShowcaseHandler

@onready var player_scoria: PlayerScoria = $PlayerScoria

func _ready() -> void:
	setup(player_scoria, 9.0)

func do_actions() -> void:
	player_scoria.position = Vector2(35.0, 214)
	player_scoria.isFacingRight = true
	timer(0.5).connect(func():
		press("run"))
	timer(2.0).connect(func():
		hold("right"))
	timer(2.7).connect(func():
		release("right")
		press("jump")
		hold("left"))
	timer(3.2).connect(func():
		release("left"))
	timer(4.0).connect(func():
		press("run"))
	timer(4.85).connect(func():
		press("crouch"))
	timer(6.0).connect(func():
		hold("right")
		press("jump"))
	timer(6.4).connect(func():
		release("right")
		press("run"))
	timer(7.5).connect(func():
		hold("left"))
	timer(7.85).connect(func():
		release("left"))

extends CharacterShowcaseHandler

@onready var player_hip: PlayerHip = $PlayerHip

func _ready() -> void:
	setup(player_hip, 6.0)

func do_actions() -> void:
	player_hip.position = Vector2(370, 228)
	timer(0.5).connect(func():
		hold("left")
	)
	timer(1.3).connect(func():
		press("jump")
		release("left"))
	timer(1.8).connect(func():
		hold("run"))
	timer(2.5).connect(func():
		hold("jump"))
	timer(3.0).connect(func():
		release("jump"))
	timer(3.5).connect(func():
		hold("crouch"))
	timer(4.2).connect(func():
		release("crouch"))
	timer(4.5).connect(func():
		release("run")
		press("jump")
		hold("right"))
	timer(5.0).connect(func():
		release("right"))

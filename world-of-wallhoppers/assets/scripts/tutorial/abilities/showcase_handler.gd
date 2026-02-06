@abstract
class_name CharacterShowcaseHandler
extends Node2D

const PLAYER: String = "p0_"
var used_events: Array[String] = [
	"left",
	"right",
	"jump",
	"run",
	"crouch",
]

var master: Timer = Timer.new()
var _character: Player
var _timers: Array[Timer] = []

func setup(character: Player, master_interval: float) -> void:
	setup_keybinds(character)
	_character = character
	add_events()
	add_child(master)
	master.timeout.connect(do_actions)
	master.wait_time = master_interval
	master.start()
	do_actions()

@abstract func do_actions() -> void

func player_control() -> void:
	master.stop()
	for t in _timers:
		if is_instance_valid(t):
			t.queue_free()
	_timers.clear()
	_character.setup_keybinds(1)

func auto_control() -> void:
	master.stop()
	for t in _timers:
		t.queue_free()
	_timers.clear()
	release_all()
	_character.setup_keybinds(0)
	master.start()
	do_actions()

func release_all() -> void:
	for action in used_events:
		release(action)

func add_events() -> void:
	for event in used_events:
		if not InputMap.has_action(PLAYER + event):
			InputMap.add_action(PLAYER + event)
	release_all()

func remove_events() -> void:
	for event in used_events:
		for action in used_events:
			release(action)
		InputMap.erase_action(PLAYER + event)

func timer(time: float) -> Signal:
	var t: Timer = Timer.new()
	add_child(t)
	_timers.append(t)
	t.one_shot = true
	t.timeout.connect(func(): t.queue_free())
	t.start(time)
	return t.timeout

func setup_keybinds(player: Player) -> void:
	player.setup_keybinds(0)

func hold(action: String) -> void:
	Input.action_press(PLAYER + action)

func release(action: String) -> void:
	Input.action_release(PLAYER + action)

func press(action: String) -> void:
	hold(action)
	release(action)

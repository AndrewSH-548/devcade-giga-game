extends PanelContainer
class_name CharacterTester

@onready var main: SubViewport = $MarginContainer/SubViewportContainer/Main
@onready var spawn_pos: Marker2D = $MarginContainer/SubViewportContainer/Main/SpawnPos
@onready var test_camera: Camera2D = $MarginContainer/SubViewportContainer/Main/TestCamera

var player: Player

var running: bool = false

func start(character: PackedScene, player_index: int):
	if running: return
	running = true
	visible = true
	
	player = character.instantiate()
	assert(player != null, "Player in Character Tester is null! Either the Character passed in did NOT extend the \"Player\" class, or an invalid PackedScene was passed!")
	
	main.add_child(player)
	player.global_position = spawn_pos.global_position
	player.setup_keybinds(player_index + 1)
	test_camera.global_position = player.global_position

func stop():
	if not running: return
	running = false
	player.queue_free()
	visible = false

func _process(delta: float) -> void:
	if not running: return
	if player != null:
		test_camera.global_position = player.global_position

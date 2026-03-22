extends StaticBody2D

@onready var spawn: Marker2D = $Spawn
@onready var destroy_area: Area2D = $DestroyArea
@onready var spawn_timer: Timer = $SpawnTimer

@export var spawning: bool = false

const BOMB = preload("res://scenes/objects/bomb/bomb.tscn")

func _ready() -> void:
	destroy_area.body_entered.connect(on_body_entered)
	if spawning:
		spawn_timer.timeout.connect(spawn_bomb)

func on_body_entered(body: Node2D) -> void:
	if body is not Bomb:
		return
	body.queue_free()

func spawn_bomb() -> void:
	var bomb: Bomb = BOMB.instantiate()
	bomb.global_position = spawn.global_position
	get_parent().add_child(bomb)

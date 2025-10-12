extends Node2D

@export var wobble_stength: float = 4.0
@export var wobble_speed: float = 1.0

var offset: float = 0.0

func _ready() -> void:
	offset = randf() * 10.0

func _process(_delta: float) -> void:
	rotation = sin(Time.get_ticks_msec() / 1000.0 * wobble_speed + offset) * wobble_stength * 0.01

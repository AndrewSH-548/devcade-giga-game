extends Node2D

@onready var button: StartMenuButton = get_parent().get_parent()
@export var speed: float = 1.0
@export var wobble_scale: float = 4.0
var start_position: Vector2
var time: float = 0.0

func _ready() -> void:
	start_position = position

func _process(delta: float) -> void:
	if button.active:
		time += delta * speed
		position = start_position + Vector2(sin(time), cos(time)) * wobble_scale

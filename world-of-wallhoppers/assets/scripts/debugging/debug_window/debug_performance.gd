extends Control

@onready var frames: Label = $MarginContainer/VBoxContainer/FPS
@onready var ticks: Label = $MarginContainer/VBoxContainer/TPS

func _process(delta: float) -> void:
	frames.text = "Frames Per Second: %.2f" % (1.0 / delta)

func _physics_process(delta: float) -> void:
	ticks.text = "Ticks Per Second: %.2f" % (1.0 / delta)

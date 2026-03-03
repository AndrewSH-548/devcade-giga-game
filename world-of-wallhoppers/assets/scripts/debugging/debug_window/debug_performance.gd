extends Control

@onready var frames: Label = $MarginContainer/VBoxContainer/FPS
@onready var ticks: Label = $MarginContainer/VBoxContainer/TPS

@onready var gpu_toggle: Button = $MarginContainer/VBoxContainer/GPUControlBox/GPUToggle
@onready var gpu_state: Label = $MarginContainer/VBoxContainer/GPUControlBox/GPUState

func _ready() -> void:
	gpu_toggle.pressed.connect(toggle_gpu_details)
	update_gpu_state_indicator()

func _process(delta: float) -> void:
	frames.text = "Frames Per Second: %.2f" % (1.0 / delta)

func _physics_process(delta: float) -> void:
	ticks.text = "Ticks Per Second: %.2f" % (1.0 / delta)

func toggle_gpu_details() -> void:
	Settings.low_detail_mode = not Settings.low_detail_mode
	update_gpu_state_indicator()

func update_gpu_state_indicator() -> void:
	if Settings.low_detail_mode:
		gpu_state.text = "OFF"
	else:
		gpu_state.text = "ON"

extends Control

@onready var input_margin: MarginContainer = $InputMargin
@onready var inputs_display: Label = $InputMargin/InputsDisplay

var inputs: Array[String] = []

func _ready() -> void:
	inputs.resize(18)
	inputs.fill(" ")

func _process(_delta: float) -> void:
	
	inputs_display.text = ""
	
	for input in inputs:
		inputs_display.text += input + "\n"

func _input(event: InputEvent) -> void:
	inputs.push_front(event.as_text() + ": " + _input_press_type(event))
	inputs.resize(18)

func _input_press_type(event: InputEvent) -> String:
	return "Pressed" if event.is_pressed() else "Released"

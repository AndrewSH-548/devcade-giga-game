extends Control

@onready var input_margin: MarginContainer = $InputMargin
@onready var inputs_display: Label = $InputMargin/InputsDisplay

var inputs: Array[String] = []

func _process(_delta: float) -> void:
	
	inputs_display.text = ""
	
	for input in inputs:
		inputs_display.text += input + "\n"
	
	inputs = []

func _input(event: InputEvent) -> void:
	inputs.append(event.as_text())

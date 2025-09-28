extends Control

@export var characters: Array[CharacterPortraitInfo]
const CHARACTER_PORTRAIT = preload("uid://br12fqlynos76")

@onready var dial: Control = $MainVertical/CharacterWheel/DialPositioner

var dials: Array[CharacterSelectDialButton]

func _ready() -> void:
	for child in dial.get_children():
		if child is CharacterSelectDialButton:
			dials.append(child)

func _process(delta: float) -> void:
	var input_player_1: Vector2 = Input.get_vector("p1_left", "p1_right", "p1_up", "p1_down")
	var input_player_2: Vector2 = Input.get_vector("p2_left", "p2_right", "p2_up", "p2_down")
	
	if input_player_1 != Vector2.ZERO:
		var closest_dot: float = Vector2.from_angle(dials[0].dial_position_angle).dot(input_player_1)
		var closest_dial: CharacterSelectDialButton = dials[0]
		
		for dial_button in dials:
			var dot: float = Vector2.from_angle(dial_button.dial_position_angle).dot(input_player_1)
			if dot > closest_dot:
				closest_dot = dot
				closest_dial = dial_button
		
		for dial_button in dials:
			dial_button.selected = dial_button == closest_dial

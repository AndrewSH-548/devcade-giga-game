extends Control

@export var characters: Array[CharacterPortraitInfo]
@onready var character_wheel: MarginContainer = $MainVertical/CharacterWheel
const CHARACTER_PORTRAIT = preload("uid://br12fqlynos76")

var current_selected: int = 0:
	set(new_value):
		current_selected = new_value
		current_selected = wrap(current_selected, 0, portraits.size())

var portrait_spacing: float = 250
var rotate_speed: float = 500

var portraits: Array[CharacterPortrait] = []

func _ready() -> void:
	var index: int = 0
	for character in characters:
		
		var portrait: CharacterPortrait = CHARACTER_PORTRAIT.instantiate()
		character_wheel.add_child(portrait)
		portrait.setup(character)
		portrait.self_index = index
		portraits.append(portrait)
		portrait.global_position.x = get_portrait_target_x(portrait)
		
		index += 1

func get_portrait_target_x(portrait: CharacterPortrait) -> float:
	return (portrait.self_index - current_selected) * portrait_spacing + DisplayServer.window_get_size().x / 2.0 - portrait.size.x / 2.0
#Did some work on the character select! There's still a lot to be done, but I've got the visuals mostly down. What do you think o
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_left"):
		current_selected -= 1
	if event.is_action_pressed("ui_right"):
		current_selected += 1

func sincos_vector(value: float) -> Vector2:
	return Vector2(sin(value), cos(value))

func _process(delta: float) -> void:
	for portrait: CharacterPortrait in portraits:
		
		var index_distance: int = wrap(current_selected - portrait.self_index, 0, portraits.size())
		
		var center_rotation: float = (float(index_distance) / int(portraits.size()) * TAU)
		
		portrait.global_position = portrait.global_position.move_toward(sincos_vector(center_rotation) * portrait_spacing, delta * rotate_speed)
		
		continue
		
		if portrait.self_index == current_selected: portrait.z_index = 2
		else: portrait.z_index = 1
		
		portrait.global_position.x = move_toward(portrait.global_position.x,
			get_portrait_target_x(portrait),
			delta * rotate_speed
		)
		
		if abs(portrait.global_position.x) < 1000:
			var distance: float = abs(DisplayServer.window_get_size().x / 2.0 - portrait.size.x / 2.0 - portrait.global_position.x)
			portrait.scale.x = 1.0 / pow(1.001, distance)
			portrait.scale.y = 1.0 / pow(1.001, distance)

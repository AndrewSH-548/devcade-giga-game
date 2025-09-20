extends Control

@export var characters: Array[CharacterPortraitInfo]
@onready var character_wheel: Control = $MainVertical/CharacterWheel
const CHARACTER_PORTRAIT = preload("uid://br12fqlynos76")

var current_selected: int = 0:
	set(new_value):
		current_selected = new_value
		current_selected = wrap(current_selected, 0, portraits.size())

var portrait_spacing: Vector2 = Vector2(500, 20)
var carousel_offset: Vector2 = Vector2(0, 200)
var rotate_speed: float = 2

var portraits: Array[CharacterPortrait] = []

func _ready() -> void:
	var index: int = portraits.size()
	
	for character in characters:
		
		var portrait: CharacterPortrait = CHARACTER_PORTRAIT.instantiate()
		character_wheel.add_child(portrait)
		portrait.setup(character)
		portrait.self_index = index
		portraits.append(portrait)
		
		index += 1
	
	for portrait in portraits:
		move_portait_carousel_position(portrait)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_left"):
		current_selected -= 1
	if event.is_action_pressed("ui_right"):
		current_selected += 1

func sincos_vector(value: float) -> Vector2:
	return Vector2(sin(value), cos(value))

func portait_offset(portrait: CharacterPortrait) -> Vector2:
	return Vector2(-portrait.size.x / 2.0 + get_viewport_rect().size.x / 2.0, 0)

func move_portait_carousel_position(portrait: CharacterPortrait, process_delta: float = -1) -> void:
	var index_distance: int = wrap(current_selected - portrait.self_index, 0, portraits.size())
	var center_rotation: float = (float(index_distance) / int(portraits.size()) * TAU)
	
	if process_delta == -1:
		portrait.rotation_position = center_rotation
	else:
		portrait.rotation_position = rotate_toward(portrait.rotation_position, center_rotation, rotate_speed * process_delta * (10.0 / portraits.size()))
	
	portrait.z_index = int((1.0 - (float(abs(wrapf(portrait.rotation_position, -PI, PI))) / TAU)) * 10) + 1
	portrait.modulate = Color.from_hsv(0.0, 0.0, (1.0 - (float(abs(wrapf(portrait.rotation_position, -PI, PI))) / TAU)))
	
	portrait.scale = Vector2.ONE * (1.0 - (float(abs(wrapf(portrait.rotation_position, -PI, PI))) / TAU))
	portrait.global_position = sincos_vector(portrait.rotation_position) * Vector2(-1, 1) * portrait_spacing + portait_offset(portrait) + carousel_offset

func _process(delta: float) -> void:
	for portrait: CharacterPortrait in portraits:
		move_portait_carousel_position(portrait, delta)

extends Button
class_name CharacterButton

@onready var select_color: ColorRect = $ButtonColor
var character_definition: CharacterDefinition
var colors: Array[Color] = [
	Color("ff759f"),
	Color("2dc8a5"),
]
var selected: Array[bool] = [false, false]

const MISSING_TEXTURE: Texture2D = preload("res://assets/sprites/missing_texture.png")
const RANDOM_TEXTURE: Texture2D = preload("res://assets/sprites/missing_texture.png")
const SIZE: int = 72

func setup(definition: CharacterDefinition) -> void:
	character_definition = definition

func _ready() -> void:
	select_color.material = select_color.material.duplicate()
	var texture: TextureRect = TextureRect.new()
	add_child(texture)
	
	pivot_offset = size / 2
	select_color.pivot_offset = pivot_offset
	
	# Use the provided texture, or the "missing" texture if none is provided
	if character_definition == null:
		texture.texture = RANDOM_TEXTURE
	elif character_definition.button_texture != null:
		texture.texture = character_definition.button_texture
	else:
		texture.texture = MISSING_TEXTURE
	# Setup the button's texture
	texture.custom_minimum_size = Vector2(SIZE, SIZE)
	texture.size_flags_horizontal = Control.SIZE_FILL
	texture.size_flags_vertical = Control.SIZE_FILL
	
	custom_minimum_size = Vector2(SIZE, SIZE)

func _process(delta: float) -> void:
	process_button_size(delta)
	process_update_shader()
	
# Makes the button grow when selected, and shrink when de-selected
func process_button_size(delta: float) -> void:
	if true in selected:
		select_color.scale = select_color.scale.move_toward(1.5 * Vector2.ONE, delta * 16.0)
	else:
		select_color.scale = select_color.scale.move_toward(1.0 * Vector2.ONE, delta * 16.0)

# Updates the shader for the "noise" texture used to show which players 
# have selected this button
func process_update_shader() -> void:
	# Show both colors if both players have selected this button
	if selected[0] and selected[1]:
		select_color.material.set_shader_parameter("colors", PackedColorArray(colors))
	# Player one only
	elif selected[0]:
		select_color.material.set_shader_parameter("colors", PackedColorArray([
			colors[0],
			colors[0],
		]))
	# Player two only
	elif selected[1]:
		select_color.material.set_shader_parameter("colors", PackedColorArray([
			colors[1],
			colors[1],
		]))

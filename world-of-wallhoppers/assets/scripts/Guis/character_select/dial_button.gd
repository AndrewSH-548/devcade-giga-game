extends Control
class_name CharacterSelectDialButton

@export var dial_id: CharacterSelect.DIAL
@export var character_name: String = ""
@export var character_scene: PackedScene

@onready var selection: Sprite2D = $Selection

var selected_by: Array[bool]
var size_speed: float = 8.0
var selected_scale: float = 1.2

func _ready() -> void:
	selection.material = selection.material.duplicate_deep(Resource.DEEP_DUPLICATE_ALL)

func _process(delta: float) -> void:
	if selection == null: return
	
	if true in selected_by:
		selection.scale = selection.scale.move_toward(Vector2.ONE * selected_scale, delta * size_speed)
	else:
		selection.scale = selection.scale.move_toward(Vector2.ONE * 0.9, delta * size_speed)
		return
	
	var shader: ShaderMaterial = (selection.material as ShaderMaterial)
	var colors: PackedColorArray = shader.get_shader_parameter("colors")
	
	for index in range(selected_by.size()):
		var selected: bool = selected_by[index]
		
		if(selected):
			colors[index] = CharacterSelect.player_colors[index]
		else:
			colors[index] = Color.WHITE
	
	var last_color: Color = Color.WHITE
	
	for color in colors:
		if color != Color.WHITE:
			last_color = color
	
	for index in range(colors.size()):
		if colors[index] == Color.WHITE:
			colors[index] = last_color
	
	shader.set_shader_parameter("colors", colors)

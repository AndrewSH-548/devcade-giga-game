extends Button
class_name StartMenuButton

@onready var shader_node: CanvasGroup = $Shader
var active: bool = false:
	set(new):
		active = new
		if active:
			modulate = Color.WHITE
		else:
			modulate = Color.DARK_SALMON
		if shader_node != null:
			shader_node.material.set_shader_parameter("active", active)

func _ready() -> void:
	active = false
	shader_node.material.set_shader_parameter("active", active)

func _physics_process(_delta: float) -> void:
	if active != has_focus(): active = has_focus()

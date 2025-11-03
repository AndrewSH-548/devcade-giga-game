extends Sprite2D
class_name StartScreenButtonCog

@onready var button: StartMenuButton = get_parent().get_parent()
@export var speed: float = 1.0

func _process(delta: float) -> void:
	if button.active:
		rotation += delta * speed

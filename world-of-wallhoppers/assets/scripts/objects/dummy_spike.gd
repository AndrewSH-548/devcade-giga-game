@tool
extends Obstacle

@onready var type: Label = $Type

func _ready() -> void:
	super._ready()
	

func _physics_process(_delta: float) -> void:
	match config:
		CONFIG.NORMAL: type.text = "Normal"
		CONFIG.LARGE: type.text = "Large"
		CONFIG.SMALL: type.text = "Small"
